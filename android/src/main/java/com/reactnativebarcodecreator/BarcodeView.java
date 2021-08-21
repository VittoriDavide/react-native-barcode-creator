package com.reactnativebarcodecreator;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.common.BitMatrix;

public class BarcodeView extends androidx.appcompat.widget.AppCompatImageView {
    int width = 400;
    int height = 400;
    String content = "";
    int foregroundColor = 0x000000;
    int background = 0xffffff;
    BarcodeFormat format = BarcodeFormat.QR_CODE;

    public void setSize(int width, int height) {
        this.width = width;
        this.height = height;
        updateQRCodeView();
    }

    public void setFormat(BarcodeFormat format) {
        this.format = format;
        updateQRCodeView();
    }

    public void setContent(String content) {
        this.content = content;
        updateQRCodeView();
    }

    public void setForegroundColor(String color) {
        try {
            int c = Color.parseColor(color);
            this.foregroundColor = c;
            updateQRCodeView();
        }catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void setBackgroundColor(String background) {
        try {
            this.background = Color.parseColor(background);
            updateQRCodeView();
        }catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateQRCodeView() {
        MultiFormatWriter multiFormatWriter = new MultiFormatWriter();
        try {
            BitMatrix bitMatrix = multiFormatWriter.encode(content, format, width, height);
            BarcodeEncoder barcodeEncoder = new BarcodeEncoder();
            Bitmap bitmap = barcodeEncoder.createBitmap(bitMatrix, foregroundColor, background);

            setImageBitmap(bitmap);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public BarcodeView(Context context) {
        super(context);
    }
}
