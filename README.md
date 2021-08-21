# react-native-barcode-creator

Component to generate QRCode, Code128, PDF417 or AZTEC natively for react native.

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
| **`value`**   | **Mandatory** - The content to add to the Barcode. | _None_                                                                                                              |
| **`style`**    | Style attributes for the view, as expected in a standard [`View`](https://facebook.github.io/react-native/docs/layout-props.html).                                                                                                                                              | _None_ |
| **`format`**     | **Mandatory** The format to show in the Barcode, it can be QR, AZTEC, PDF417, CODE128.                                                                                                                                                                                                             | `BarcodeFormat.QR`                                                                                                              |
| **`background`** | The Background Color of the Barcode.                                                                                                                                           | `white`                                                                                                             |
| **`foregroundColor`** | The foreground color to use on the Barcode.                                                                                                                                           | `black`    

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
