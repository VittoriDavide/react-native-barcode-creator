import * as React from 'react';

import { StyleSheet, View } from 'react-native';
import {
  BarcodeFormat,
  BarcodeCreatorView,
} from 'react-native-barcode-creator';

export default function App() {
  return (
    <View style={styles.container}>
      <BarcodeCreatorView
        value={'Hello World'}
        background={'#FFFFFF'}
        foregroundColor={'#000000'}
        format={BarcodeFormat.AZTEC}
        style={styles.box}
      />
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
