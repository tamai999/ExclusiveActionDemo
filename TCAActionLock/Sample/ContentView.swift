import ComposableArchitecture
import SwiftUI

@Reducer
struct ContentFeature {
  @ObservableState
  struct State: LockState {
    var lockLevel: LockLevel = .none
    var counter = 0
  }
  
  enum Action: LockAction {
    case tapExclusiveButton
    case tapNonExclusiveButton
    case updateState(Int)
    
    // ロックするアクション、アンロックするアクション、排他しないアクションを定義
    var lockMode: ActionLockMode {
      switch self {
      case .tapExclusiveButton:
          .exclusiveLock
      case .tapNonExclusiveButton:
          .cancellableLock
      case .updateState:
          .unlock
      }
    }
  }
  
  private enum CancelID { case updateState }
  
  var body: some ReducerOf<Self> {
    LockReduce { state, action in
      switch action {
      case .tapExclusiveButton:
        let next = state.counter + 1
        return .concatenate(
          // 他の実行中の処理をキャンセル
          .cancel(id: CancelID.updateState),
          .run { send in
            // 何か重い処理
            try? await Task.sleep(for: .seconds(1))
            // 処理結果反映
            await send(.updateState(next))
          }
        )
        
      case .tapNonExclusiveButton:
        let next = state.counter + 1
        return .run { send in
          // 何か重い処理
          try? await Task.sleep(for: .seconds(1))
          
          if Task.isCancelled {
            print("Task is Cancelled.")
            return
          }
          // 処理結果反映
          await send(.updateState(next))
        }
        .cancellable(id: CancelID.updateState, cancelInFlight: true)
        
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
    VStack(spacing: 20) {
      Button("Exclusive Button") {
        store.send(.tapExclusiveButton)
      }
      
      Button("Non-Exclusive Button") {
        store.send(.tapNonExclusiveButton)
      }
      
      Text("counter: \(store.counter)")
    }
    .padding()
  }
}
