package com.kotech.soundpluguin;

import java.util.ArrayList;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** SoundpluguinPlugin */
public class SoundpluguinPlugin implements FlutterPlugin, MethodCallHandler {
  private MethodChannel channel;
  private Synth synth;
  private static final String channelName= "soundpluguin";

  private  static  void setup(SoundpluguinPlugin plugin, BinaryMessenger binaryMessenger ){
    plugin.channel= new MethodChannel(binaryMessenger,channelName);
    plugin.channel.setMethodCallHandler(plugin);
    plugin.synth= new Synth();
    plugin.synth.start();
  }


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "soundpluguin");
    channel.setMethodCallHandler(this);
    setup(this,flutterPluginBinding.getBinaryMessenger());

  }

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "soundpluguin");
    channel.setMethodCallHandler(new SoundpluguinPlugin());
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      case "onKeyDown":
        try {
          ArrayList arguments = (ArrayList) call.arguments;
          int numKeyDown = synth.keyDown((Integer) arguments.get(0));
          result.success(numKeyDown);
        } catch (Exception ex) {
          result.error("1", ex.getMessage(), ex.getStackTrace());
        }
        break;
      case "onKeyUp":
        try {
          ArrayList arguments = (ArrayList) call.arguments;
          int numKeyDown = synth.keyUp((Integer) arguments.get(0));
          result.success(numKeyDown);
        } catch (Exception ex) {
          result.error("1", ex.getMessage(), ex.getStackTrace());
        }
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
