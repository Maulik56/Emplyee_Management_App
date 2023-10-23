import UIKit
import Flutter
import GoogleMaps
import awesome_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    SwiftAwesomeNotificationsPlugin.setPluginRegistrantCallback { registry in
              SwiftAwesomeNotificationsPlugin.register(
                with: registry.registrar(forPlugin: "io.flutter.plugins.awesomenotifications.AwesomeNotificationsPlugin")!)
    }
    // TODO: Add your Google Maps API key
    GMSServices.provideAPIKey("AIzaSyBLjgELUHE9X1z5OI0if3tMRDG5nWK2Rt8")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
