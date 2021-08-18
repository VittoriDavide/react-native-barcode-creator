import { requireNativeComponent, ViewStyle } from 'react-native';

type BarcodeCreatorProps = {
  color: string;
  style: ViewStyle;
};

export const BarcodeCreatorViewManager = requireNativeComponent<BarcodeCreatorProps>(
'BarcodeCreatorView'
);

export default BarcodeCreatorViewManager;
