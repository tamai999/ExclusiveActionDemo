import ComposableArchitecture

/// `LockState` manages exclusive control to prevent TCA actions from being executed concurrently.
///
/// This is mainly used to:
/// - Prevent multiple instances of the same asynchronous action from running simultaneously
/// - Avoid redundant triggers caused by rapid user input (e.g., button spamming)
public protocol LockState {
  mutating func lock()
  mutating func unlock()
  var isLocked: Bool { get set }
}

public extension LockState {
  mutating func lock() {
    isLocked = true
  }
  
  mutating func unlock() {
    isLocked = false
  }
}
