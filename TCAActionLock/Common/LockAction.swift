import ComposableArchitecture

/// Represents the locking behavior associated with an action.
public enum ActionLockMode {
  /// The action does not affect locking state.
  case none
  /// The action requests a lock to be acquired.
  /// If a lock is already held, the action may be ignored or deferred.
  case exclusiveLock
  /// The action requests a **reentrant** lock to be acquired.
  case cancellableLock
  /// The action requests a previously acquired lock to be released.
  case unlock
}

/// A protocol for actions that participate in lock-based mutual exclusion.
///
/// Use `lockMode` to declare whether the action should acquire or release a lock,
/// or has no effect on the lock state.
public protocol LockAction {
  var lockMode: ActionLockMode { get }
}
