import ComposableArchitecture
import SwiftUI

@Reducer
struct ContentFeature {
  @ObservableState
  struct State: LockState {
    var isLocked: Bool = false
    var counter = 0
  }
  
  enum Action: LockAction {
    case tapButton
    case updateState(Int)
    
    // ロックするアクション、アンロックするアクションを定義
    var lockMode: ActionLockMode {
      switch self {
      case .tapButton:
          .lock
      case .updateState:
          .unlock
      }
    }
  }
  
  var body: some ReducerOf<Self> {
    LockReduce { state, action in
      switch action {
      case .tapButton:
        let next = state.counter + 1
        return .run { send in
          // 何か重い処理
          try? await Task.sleep(for: .seconds(1))
          // 処理結果反映
          await send(.updateState(next))
        }
        
      case let .updateState(next):
        state.counter = next
        return .none
      }
    }
  }
}

struct ContentView: View {
  @Bindable public var store: StoreOf<ContentFeature>
  
  var body: some View {
    VStack {
      Button("Tap me") {
        store.send(.tapButton)
      }
      Text("counter: \(store.counter)")
    }
    .padding()
  }
}
