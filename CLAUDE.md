# CLAUDE.md

Guidance for Claude Code when working in this repository.

## What this is

`react-native-barcode-creator` — a React Native **view component** library that renders
barcodes natively (no JS/SVG rendering). Supported formats: `QR_CODE`, `AZTEC`, `CODE_128`,
`PDF_417`, `EAN_13`, `UPC_A`.

Built for the **New Architecture (Fabric)** via codegen, with legacy Paper bridge files kept
alongside for old-architecture consumers.

## Layout

```
src/                       JS/TS surface (published as `source`/`react-native` entry)
  index.tsx                Public API: BarcodeCreatorView, BarcodeFormat
  BarcodeCreatorNativeComponent.ts   codegenNativeComponent spec — the codegen source of truth
android/src/main/java/com/reactnativebarcodecreator/
  BarcodeCreatorViewManager.java     Fabric ViewManager (implements generated *ManagerInterface)
  BarcodeView.java                   AppCompatImageView, ZXing encoding, all rendering logic
  BarcodeEncoder.java                BitMatrix -> Bitmap helper (adapted from ZXing)
  BarcodeCreatorPackage.java         ReactPackage registration
ios/
  BarcodeCreatorViewManager.swift    BarcodeCreatorView (UIView) — CoreImage encoding, all logic
  BarcodeCreatorViewComponentView.mm Fabric component view, bridges C++ props -> Swift view
  BarcodeCreatorViewManager.m        Legacy Paper RCT_EXTERN_MODULE prop exports
  CIFilters/CIEANBarcodeGenerator.swift  Custom CIFilter — CoreImage has no EAN/UPC generator
example/                   Expo app used for manual testing (see caveats below)
lib/                       Build output from react-native-builder-bob — never edit, gitignored
```

## Commands

```bash
yarn typecheck   # tsc --noEmit
yarn lint        # eslint "**/*.{js,ts,tsx}"
yarn test        # jest (currently only an it.todo placeholder)
yarn prepare     # bob build -> lib/{commonjs,module,typescript}
yarn clean       # remove build dirs and lib/
```

## Adding or changing a prop

Props flow through codegen, so a change touches four places in order:

1. `src/BarcodeCreatorNativeComponent.ts` — add to `NativeProps`. Codegen only accepts flat,
   primitive-ish types here; keep rich types (objects, unions) in `src/index.tsx` and flatten
   them before passing down. This is why `encodedValue: {base64, messageEncoded}` is split into
   two string props at the native boundary.
2. `src/index.tsx` — expose the ergonomic public prop and map it to the native prop.
3. Android: implement the generated `BarcodeCreatorViewManagerInterface` setter in
   `BarcodeCreatorViewManager.java` (it must also carry `@ReactProp`), then act on it in
   `BarcodeView.java`.
4. iOS: add the property to `BarcodeCreatorView` in `BarcodeCreatorViewManager.swift`, copy it
   in `updateProps:` in `BarcodeCreatorViewComponentView.mm`, **and** add the
   `RCT_EXPORT_VIEW_PROPERTY` line in `BarcodeCreatorViewManager.m` for old-arch consumers.

Missing step 3 or 4 fails at build time (interface not satisfied / prop silently dropped).
Codegen artifacts regenerate on the consuming app's build — `yarn prepare` alone does not
refresh them; rebuild the native app.

## Platform behaviour differences

The two platforms use completely different encoders, so behaviour diverges in ways that matter:

| | iOS | Android |
|---|---|---|
| Engine | CoreImage `CIFilter` | ZXing `MultiFormatWriter` |
| EAN-13 / UPC-A | custom `CIEANBarcodeGenerator` | ZXing built-in |
| Colors accepted | `#RGB`/`#RRGGBB`/`#RRGGBBAA`, `rgb()`, `rgba()` | `#RGB`/`#RRGGBB`/`#RRGGBBAA` only |
| Invalid input | filter returns nil, previous image stays | bitmap cleared, warning logged |
| Value charset | must be ISO-8859-1 encodable (hard requirement of `inputMessage`) | any string |

Coloring on iOS is done by rendering a template image and setting `tintColor`/`backgroundColor`;
on Android the pixels are written directly into the `Bitmap`.

## Landmines

- **`BarcodeEncoder.createBitmap` args look swapped and are correct.** The signature is
  `(matrix, foreground, background)` but a *set* module pixel is painted with the `background`
  param; `BarcodeView` compensates by calling `createBitmap(matrix, background, foregroundColor)`.
  Two wrongs currently cancel out — don't "fix" one side alone.
- **Never let an exception escape the Android render path.** `updateQRCodeView()` pre-validates
  content and swallows encode failures on purpose: under Fabric a throw here tears the native
  view down and produces `Unable to find view for viewState`. Clear the bitmap instead.
- **Base64 for `encodedValue` is URL-safe.** Android decodes with `Base64.URL_SAFE`; iOS manually
  maps `-`→`+` and `_`→`/`. Keep both sides in sync.
- **`android/gradle.properties` defines no `BarcodeCreator_*` SDK versions.** The build relies on
  the consuming app's `rootProject.ext` supplying `compileSdkVersion`/`minSdkVersion`/
  `targetSdkVersion`.
- **The `.mm` file is wrapped in `#ifdef RCT_NEW_ARCH_ENABLED`.** Edits there are invisible on
  old-architecture builds.

## Example app caveats

`example/` is a standalone Expo 55 / RN 0.83 app (expo-router, dev client — Expo Go will not
work). It is **not** wired to the local source despite the root `workspaces: ["example"]`:

- it has its own `yarn.lock`, `.yarnrc.yml`, and a nested `.git`;
- it depends on `react-native-barcode-creator@0.2.0-beta.0` — an exact range that the local
  workspace's `0.2.0` does not satisfy — so Yarn resolves it **from npm** rather than linking the
  workspace. `example/node_modules/react-native-barcode-creator` is a real published copy, not a
  symlink, and local `src/`/native changes do not appear there. To test changes, point the
  dependency at the workspace (`workspace:*` or `file:..`) and re-run `npx expo prebuild` /
  `pod install`;
- the root `yarn example` script targets workspace `react-native-barcode-creator-example`, but
  the app's package name is `rnbc-app-55`, so that script does not resolve. Run commands from
  inside `example/` (`npx expo run:ios`, `npx expo run:android`).

`CONTRIBUTING.md` still describes the older RN-CLI example setup and an
`example/ios/BarcodeCreatorExample.xcworkspace` that no longer exists — prefer this file.

## Tooling state

`yarn typecheck`, `yarn lint`, `yarn test`, and `yarn prepare` all pass. Keep them that way.

- **`yarn lint` still emits 35 warnings, all in `example/`.** 34 are `react/react-in-jsx-scope`
  false positives — the root `@react-native/eslint-config@0.72.2` predates the automatic JSX
  runtime that React 17+ uses. They are warnings, so lint exits 0. Silencing them means
  updating the shared ESLint config.
- **`yarn test` runs one `it.todo` placeholder.** There is no real test coverage; treat a green
  `yarn test` as "the toolchain works", not "the behaviour is verified".
- **`yarn typecheck` runs against `tsconfig.build.json`, not `tsconfig.json`** — deliberately.
  The root config also pulls in `example/`, whose `@/*` aliases live in `example/tsconfig.json`
  and are invisible from the root, and whose `react-native@0.83.2` collides with the root's
  `0.73.2`. Both copies declare the ambient module
  `react-native/Libraries/Utilities/codegenNativeComponent`, and their `HostComponent<P>`
  definitions differ (`& Readonly<NativeMethods>` vs `& HostInstance`), so the otherwise
  no-op cast in `src/BarcodeCreatorNativeComponent.ts` fails to check. Don't "fix" that cast,
  and don't point `typecheck` back at `tsconfig.json`.

The root toolchain is older than what the library targets: it dev-depends on `react-native@0.73.2`
/ `react@18.2.0` while the example runs RN 0.83 / React 19. `@types/react-native` (obsolete since
RN 0.71 ships its own types) and a `resolutions` pin holding `@types/react` at 17 have been
removed; `@types/react` now follows `^18`, matching the root `react`. `babel.config.js` uses
`module:@react-native/babel-preset` — the pre-0.73 `metro-react-native-babel-preset` name no
longer resolves and silently breaks both Jest and ESLint parsing.

`.yarn/cache` is partially checked in (~1000 zips tracked), but `.gitignore` ignores `.yarn/*`
except `patches`/`plugins`/`releases`/`sdks`/`versions` — so new cache entries are never added
while removed ones show up as deletions. Dependency changes will produce `D .yarn/cache/*.zip`
lines in `git status`; that is expected.

## Conventions

- Commits follow [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`,
  `docs:`, `chore:`, …); enforced by commitlint. Releases go through `release-it` with the
  angular changelog preset.
- Prettier: single quotes, 2-space tabs, ES5 trailing commas, consistent quote props.
- Package manager is **yarn 3.6.1** (Plug'n'Play disabled, `node-modules` linker).
