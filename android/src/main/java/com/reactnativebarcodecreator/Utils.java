package com.reactnativebarcodecreator;

import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.modules.core.ExceptionsManagerModule;

public class Utils {
  public static void showException(ReactContext context, Exception e) {
    ExceptionsManagerModule manager = context.getNativeModule(ExceptionsManagerModule.class);
    WritableNativeMap map = new WritableNativeMap();
    map.putString("message", e.getMessage());
    manager.reportException(map);
  }

}
