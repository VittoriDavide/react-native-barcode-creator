package com.reactnativebarcodecreator;

import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.google.zxing.BarcodeFormat;

public class BarcodeCreatorViewManager extends SimpleViewManager<View> {
    public static final String REACT_CLASS = "BarcodeCreatorView";

    ReactApplicationContext mCallerContext;

  public BarcodeCreatorViewManager(ReactApplicationContext reactContext) {
    mCallerContext = reactContext;
  }

  @Override
  public String getName() {
    return REACT_CLASS;
  }

  @NonNull
  @Override
  protected BarcodeView createViewInstance(@NonNull ThemedReactContext reactContext) {
    BarcodeView qrCodeView = new BarcodeView(reactContext);
    return qrCodeView;
  }

  @ReactProp(name = "format")
  public void setFormat(BarcodeView view, @Nullable String format) {
    view.setFormat(BarcodeFormat.valueOf(format));
  }
  @ReactProp(name = "foregroundColor")
  public void setForeground(BarcodeView view, @Nullable String color) {
    view.setForegroundColor(color);
  }

  @ReactProp(name = "background")
  public void setBackground(BarcodeView view, @Nullable String color) {
    view.setBackgroundColor(color);
  }
  @ReactProp(name = "value")
  public void setValue(BarcodeView view, @Nullable String content) {
    view.setContent(content);
  }

}
