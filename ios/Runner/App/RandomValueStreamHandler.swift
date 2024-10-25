import Foundation
import Flutter

class RandomValueStreamHandler: NSObject, FlutterStreamHandler {
    static let shared = RandomValueStreamHandler()

    private var eventChannel: FlutterEventChannel?
    var eventSink: FlutterEventSink?
    var timer: Timer?

    func configureEventChannel(controller: FlutterViewController) {
        eventChannel = FlutterEventChannel(name: "com.ducos.native/random_value_stream",
                                           binaryMessenger: controller.binaryMessenger)
        eventChannel?.setStreamHandler(self)
    }

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let randomValue = Int.random(in: 1...100)
            print(randomValue)
            self.eventSink?(randomValue)
        }
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        // Stop the timer when the stream is canceled
        timer?.invalidate()
        timer = nil
        eventSink = nil
        return nil
    }
}
