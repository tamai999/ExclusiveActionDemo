import ComposableArchitecture

/// A reducer wrapper that enforces mutual exclusion (locking) for actions,
/// based on their `LockAction.lockMode` and the current state's lock level.
///
/// Locking behavior:
/// - `.exclusiveLock`: Acquires a strong lock. If the state is already locked (exclusively or otherwise), the action is skipped.
/// - `.cancellableLock`: Acquires a weaker lock. If the state is already exclusively locked, the action is skipped. Otherwise, the lock is replaced.
/// - `.unlock`: Releases the current lock, allowing new actions to proceed.
/// - `.none`: No locking behavior. The action proceeds as usual.
///
/// This mechanism helps prevent overlapping side effects such as duplicate API calls,
/// unintended reentrancy, or excessive button tapping.
public struct LockReduce<State: LockState, Action: LockAction>: Reducer {
  @usableFromInline
  let reduce: (inout State, Action) -> Effect<Action>

  @usableFromInline
  init(
    internal reduce: @escaping (inout State, Action) -> Effect<Action>
  ) {
    self.reduce = reduce
  }

  @inlinable
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action.lockMode {
    case .exclusiveLock:
      if state.lockLevel == .exclusive {
        print("🔒 Action skipped: already locked.")
        return .none
      } else {
        print("🔒 Exclusive Lock acquired.")
        state.exclusiveLock()
      }

    case .cancellableLock:
      if state.lockLevel == .exclusive {
        print("🔒 Action skipped: already locked.")
        return .none
      } else {
        print("🔒 Cancellable Lock acquired.")
        state.cancellableLock()
      }
      
    case .unlock:
      print("🔓 Lock released.")
      state.unlock()

    case .none:
      break
    }

    return reduce(&state, action)
  }
}
