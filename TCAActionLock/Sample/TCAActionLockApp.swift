import ComposableArchitecture
import SwiftUI

@main
struct TCAActionLockApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(
        store: Store(initialState: ContentFeature.State()) {
          ContentFeature()
        }
      )
    }
  }
}
