import { requireNativeComponent, ViewStyle, NativeModules } from 'react-native';

type BarcodeCreatorProps = {
  format: string;
  value: string;
  background: string;
  foregroundColor: string;
  style: ViewStyle;
};

export const BarcodeCreatorViewManager = requireNativeComponent<BarcodeCreatorProps>(
'BarcodeCreatorView'
);

export default BarcodeCreatorViewManager;

export const BarcodeFormat = NativeModules.BarcodeCreatorViewManager.getConstants();
