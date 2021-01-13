import Flutter
import UIKit
import LoginWithAmazon


public class SwiftFlutterAuthPlugin: NSObject, FlutterPlugin,AIAuthenticationDelegate, {
  var x:Any?
  var y:Any?
  var flutterResult:FlutterResult?
  func requestDidSucceed(_ apiResult: APIResult!) {
    switch (apiResult.api) {
    case API.authorizeUser:
        LoginWithAmazonProxy.sharedInstance.getAccessToken(delegate: self)        
    case API.getAccessToken:
        guard let LWAtoken = apiResult.result as? String else { return }
        print("LWA Access Token: \(LWAtoken)")
        y = LWAtoken
        // Get the user profile from LWA (OPTIONAL)
        LoginWithAmazonProxy.sharedInstance.getUserProfile(delegate: self)
        
    case API.getProfile:
        print("LWA User Profile: \(String(describing: apiResult.result))")
        x = apiResult.result
        flutterResult!(["user":x,"token":y])
        
    case API.clearAuthorizationState:
        print("user logged out from LWA")
        
    default:
        print("unsupported")
    }
  }
  
  func requestDidFail(_ errorResponse: APIError!) {
      print("Error: \(errorResponse.error.message ?? "nil")")
  }
  
  public static func register(with registrar: FlutterPluginRegistrar) {
  let amazonChannel = FlutterMethodChannel(name: "authProvider/amazon",binaryMessenger: controller.binaryMessenger)    

  amazonChannel.setMethodCallHandler({
        [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        self?.flutterResult = result
      // Note: this method is invoked on the UI thread.
      // guard call.method == "loginWithAmazon" else {
      //   result(FlutterMethodNotImplemented)
      //   return
      // }
      //   (self?.loginWithAmazon(result:result))!
      
      if(call.method == "loginWithAmazon"){
        (self!.loginWithAmazon())
      }else if(
        call.method == "amazonLogout"
      ){
        (self!.amazonLogout(result:result))
      }
      else{
        result(FlutterMethodNotImplemented)
        return
      }
    })
  }

  func loginWithAmazon(){
    LoginWithAmazonProxy.sharedInstance.login(delegate: self)
  }

  func amazonLogout(result: FlutterResult){
    LoginWithAmazonProxy.sharedInstance.logout(delegate: self)
      x = nil
      y = nil
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }

  GeneratedPluginRegistrant.register(with: self)
  FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)
}
