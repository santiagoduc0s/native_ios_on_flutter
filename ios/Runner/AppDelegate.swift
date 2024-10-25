import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        let nativeMapViewFactory = NativeMapViewFactory()
        registrar(forPlugin: "NativeMapView")?.register(nativeMapViewFactory, withId: "native_map_view")
        
        PlatformChannelHandler.shared.configureMethodChannel(controller: controller)
        RandomValueStreamHandler.shared.configureEventChannel(controller: controller)
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
