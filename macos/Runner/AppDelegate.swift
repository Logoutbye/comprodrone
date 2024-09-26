// import Cocoa
// import FlutterMacOS

// @main
// class AppDelegate: FlutterAppDelegate {
//   override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
//     return true
//   }
// }
import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: NSApplication,
    didFinishLaunchingWithOptions launchOptions: [NSApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    RegisterGeneratedPlugins(registry: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
