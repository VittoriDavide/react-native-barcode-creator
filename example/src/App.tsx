import * as React from 'react';

import { StyleSheet, View } from 'react-native';
import BarcodeCreatorViewManager, { BarcodeFormat } from 'react-native-barcode-creator';

export default function App() {
  return (
    <View style={styles.container}>
      <BarcodeCreatorViewManager
        value={"100"}
        background={"#000000"}
        foregroundColor={"#FFFFFF"}
        format={BarcodeFormat.QR}
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
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
