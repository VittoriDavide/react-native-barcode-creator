import {
  requireNativeComponent,
  UIManager,
  Platform,
  type ViewStyle,
  NativeModules,
} from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-barcode-creator' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n'

type BarcodeCreatorProps = {
  format: string;
  value: string;
  background: string;
  foregroundColor: string;
  style: ViewStyle;
};

const ComponentName = 'BarcodeCreatorView';

export const BarcodeCreatorView =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? requireNativeComponent<BarcodeCreatorProps>(ComponentName)
    : () => {
        throw new Error(LINKING_ERROR);
      };
export const BarcodeFormat = {
  AZTEC: NativeModules.BarcodeCreatorViewManager.getConstants().AZTEC,
  CODE128: NativeModules.BarcodeCreatorViewManager.getConstants().CODE128,
  PDF417: NativeModules.BarcodeCreatorViewManager.getConstants().PDF417,
  QR: NativeModules.BarcodeCreatorViewManager.getConstants().QR,
  EAN13: NativeModules.BarcodeCreatorViewManager.getConstants().EAN13,
  UPCA: NativeModules.BarcodeCreatorViewManager.getConstants().UPCA,
};

export type { BarcodeCreatorProps };
