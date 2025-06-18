import ComposableArchitecture

/// A reducer wrapper that enforces mutual exclusion (locking) for certain actions,
/// based on their `LockAction` mode and the current lock state.
///
/// If an action declares `.lock` and the state is already locked, the reducer does nothing.
/// If `.lock` is declared and the state is not locked, it acquires the lock before reducing.
/// If `.unlock` is declared, it releases the lock.
///
/// This mechanism helps avoid overlapping side effects (e.g., button spamming, duplicate API calls).
public struct LockReduce<State: LockState, Action: LockAction>: Reducer {
  @usableFromInline
  let reduce: (inout State, Action) -> Effect<Action>

  @usableFromInline
  init(
    internal reduce: @escaping (inout State, Action) -> Effect<Action>
  ) {
    self.reduce = reduce
  }

  /// The main reduce function that wraps the original logic with lock handling.
  ///
  /// - Parameters:
  ///   - state: The current mutable state.
  ///   - action: The dispatched action that may request locking behavior.
  /// - Returns: An `Effect` that describes any asynchronous work to be performed.
  @inlinable
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    // Determine what kind of lock operation (if any) is required by the action
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
