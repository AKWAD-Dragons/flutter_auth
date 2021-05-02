import Flutter
import UIKit


public class SwiftFlutterAuthPlugin: NSObject, FlutterPlugin {
  var x:Any?
  var y:Any?
  var flutterResult:FlutterResult?
  
  
  public static func register(with registrar: FlutterPluginRegistrar) {
  // let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
  // let amazonChannel = FlutterMethodChannel(name: "authProvider/amazon",binaryMessenger: controller.binaryMessenger)    

  // amazonChannel.setMethodCallHandler({
  //       [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
  //   })
  }

  func loginWithAmazon(){
  }

  func amazonLogout(result: FlutterResult){
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }

  // FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)
}
