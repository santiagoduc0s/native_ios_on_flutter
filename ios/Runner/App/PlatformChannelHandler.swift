import Flutter
import UIKit

class PlatformChannelHandler {
    static let shared = PlatformChannelHandler()

    func configureMethodChannel(controller: FlutterViewController) {
        let flutterChannel = FlutterMethodChannel(name: "com.ducos.native/platform_channel_handler",
                                                  binaryMessenger: controller.binaryMessenger)
        
        flutterChannel.setMethodCallHandler({ (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "getPlatformVersion" {
                self.getPlatformVersion(result: result)
            } else {
                result(FlutterError(code: "UNDEFINDE_METHOD", message: "", details: nil))
            }
        })
    }

    private func getPlatformVersion(result: FlutterResult) {
        result("iOS " + UIDevice.current.systemVersion)
    }
}
