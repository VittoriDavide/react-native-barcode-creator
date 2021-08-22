import * as React from 'react';

import { StyleSheet, View } from 'react-native';
import BarcodeCreatorViewManager, { BarcodeFormat } from 'react-native-barcode-creator';

export default function App() {
  console.warn(BarcodeFormat)
  return (
    <View style={styles.container}>
      <BarcodeCreatorViewManager
        value={""}
        background={"#000000"}
        foregroundColor={"#FFFFFF"}
        format={BarcodeFormat.EAN13}
        style={styles.box} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 50,
    height: 50,
    marginVertical: 20,
  },
});
