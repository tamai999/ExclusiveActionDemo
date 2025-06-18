import ComposableArchitecture

/// Represents the level of locking behavior an action requires.
///
/// This can be used to determine how strictly an action should be excluded
/// from concurrent execution with other actions.
public enum LockLevel {
  /// The action requires strong mutual exclusion.
  /// If another exclusive action is already running, this action should be skipped or delayed.
  case exclusive

  /// The action can be cancelled or replaced by another action.
  /// Useful for debounce-like or restartable effects.
  case cancellable

  /// The action does not require any locking behavior.
  case none
}

/// `LockState` manages exclusive control to prevent TCA actions from being executed concurrently.
///
/// This is mainly used to:
/// - Prevent multiple instances of the same asynchronous action from running simultaneously
/// - Avoid redundant triggers caused by rapid user input (e.g., button spamming)
public protocol LockState {
  mutating func exclusiveLock()
  mutating func cancellableLock()
  mutating func unlock()
  var lockLevel: LockLevel { get set }
}

public extension LockState {
  mutating func exclusiveLock() {
    lockLevel = .exclusive
  }
  
  mutating func cancellableLock() {
    lockLevel = .cancellable
  }
  
  mutating func unlock() {
    lockLevel = .none
  }
}
