# react-native-barcode-creator

Component to generate QRCode, Code128, PDF417, AZTEC, EAN13 or UPCA natively for react native.

## Installation

```sh
npm install react-native-barcode-creator
```
Go to your ios folder and run:
```sh
pod install
```

## Usage

```js
import BarcodeCreatorViewManager, { BarcodeFormat } from 'react-native-barcode-creator';

 <BarcodeCreatorViewManager
        value={"100"}
        background={"#000000"}
        foregroundColor={"#FFFFFF"}
        format={BarcodeFormat.QR}
        style={styles.box} />

```

## Props

| Prop           | Description                                                                                                                                                                                                                                                                     | Default                                                                                                             |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| **`value`**   | **Mandatory** - The content to add to the Barcode. (EAN-13 should be 13 integers on a string like "5901234123457", UPCA has to be 12 characters "590123412345") | _None_                                                                                                              |
| **`style`**    | Style attributes for the view, as expected in a standard [`View`](https://facebook.github.io/react-native/docs/layout-props.html).                                                                                                                                              | _None_ |
| **`format`**     | **Mandatory** The format to show in the Barcode, it can be QR, AZTEC, PDF417, CODE128, EAN13 and UPCA.                                                                                                                                                                                                             | `BarcodeFormat.QR`                                                                                                              |
| **`background`** | The Background Color of the Barcode.                                                                                                                                           | `white`                                                                                                             |
| **`foregroundColor`** | The foreground color to use on the Barcode.                                                                                                                                           | `black`



## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
