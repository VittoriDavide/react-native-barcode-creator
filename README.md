# Natively Generate Barcodes with React Native

* **react-native-barcode-creator** is a React Native library designed for native generation of QR Codes, Code128, PDF417, AZTEC, EAN-13, and UPC-A.

## Installation

### React Native

```sh
yarn add react-native-barcode-creator
cd ios && pod install
```

### Expo

```sh
npx expo install react-native-barcode-creator
npx expo prebuild
```

remember to use the Development Build and not Expo Go


## Usage

### Props

| Prop                  | Description                                                                                                                                                                        | Default            |
|-----------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------|
| **`value`**           | **Mandatory** - The content to add to the Barcode. (EAN-13 should be 13 integers on a string like "5901234123457", UPCA has to be 12 characters "590123412345")                    | _None_             |
| **`encodedValue`**    | Use instead of value, accepts object with base64 and messageEncoded. MessageEncoded only accepts **"ISO-8859-1"**, **"UTF-8"**, **"UTF-16"**. Ex: {base64: "", messageEncoded: ""} | _None_             |
| **`style`**           | Style attributes for the view, as expected in a standard [`View`](https://facebook.github.io/react-native/docs/layout-props.html).                                                 | _None_             |
| **`format`**          | **Mandatory** The format to show in the Barcode, it can be QR, AZTEC, PDF417, CODE128, EAN13 and UPCA.                                                                             | `BarcodeFormat.QR` |
| **`background`**      | The Background Color of the Barcode. (rgba or rgb)                                                                                                                                 | `#FFFFFF`          |
| **`foregroundColor`** | The foreground color to use on the Barcode. (rgba or rgb)                                                                                                                          |                    |

### Example

```js
import { BarcodeCreatorView } from "react-native-barcode-creator";

<BarcodeCreatorView
  value={'Hello World'}
  background={'#FFFFFF'}
  foregroundColor={'#000000'}
  format={BarcodeFormat.AZTEC}
  style={styles.box}
/>
```

## Screenshots

![alt text](https://randomstuffshared.s3.eu-west-2.amazonaws.com/screenshot.png)


## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
