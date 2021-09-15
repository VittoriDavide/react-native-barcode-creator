import * as React from 'react';

import { StyleSheet, View } from 'react-native';
import BarcodeCreatorViewManager, { BarcodeFormat } from 'react-native-barcode-creator';

export default function App() {
  console.warn(BarcodeFormat)
  return (
    <View style={styles.container}>
      <BarcodeCreatorViewManager
        value={"Hello World"}
        background={"#FFFFFF"}
        foregroundColor={"#000000"}
        format={BarcodeFormat.AZTEC}
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
    width: 200,
    height: 200,
    marginVertical: 20,
  },
});
