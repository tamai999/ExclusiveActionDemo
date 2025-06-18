# ExclusiveActionDemo

A sample project demonstrating **mutual exclusion of actions** in [The Composable Architecture (TCA)](https://github.com/pointfreeco/swift-composable-architecture).

👉 [View on GitHub](https://github.com/tamai999/ExclusiveActionDemo/tree/main)

---

## 🧩 Overview

This project extends TCA reducers to support **action-level locking**, preventing overlapping execution of asynchronous or duplicate actions.

---

## 🔐 Lock Levels

Two levels of lock control are supported:

### 1. `exclusiveLock`
- Once acquired, **all other actions with any lock level are ignored** until the lock is released.
- Useful for strict mutual exclusion where only one effect should run at a time.

### 2. `cancellableLock`
- Allows repeated acquisition.
- Ongoing effects are **expected to be cancelled** when a new instance of the action is dispatched.
- Ideal for restartable-style behaviors.

---

## ⚙️ Usage

Each action declares its lock level using the `LockAction.lockMode` property.
