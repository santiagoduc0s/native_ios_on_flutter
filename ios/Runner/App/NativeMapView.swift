import UIKit
import MapKit
import Flutter

class NativeMapView: NSObject, FlutterPlatformView {
    private var mapView: MKMapView

    init(frame: CGRect) {
        self.mapView = MKMapView(frame: frame)
        super.init()
        setupMap()
    }
    
    func view() -> UIView {
        return mapView
    }
    
    private func setupMap() {
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
    }
}

class NativeMapViewFactory: NSObject, FlutterPlatformViewFactory {
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return NativeMapView(frame: frame)
    }
}
