# Resilience Operators

## Retry

One of the resilience operations whose purpose is to repeat failed executions a number of times.

**Why I should use it?**

Many faults are transient and may self-correct after a short time. So this helps in auto-recovery of transient errors.

### Usage
```smalltalk
Retry
 value: [ "operation to execute" ]
 configuredBy: [:retry | "configuration options" ]
```

The block to be evaluated can optionally receive the current attempt  number in a block argument:

```smalltalk
Retry
 value: [:attemptNumber | "operation to execute" ]
 configuredBy: [:retry | retry upTo: 5 ]
```

### Configuration Options
These options are sent to the `retry` instance provided in the second block.

-	`upTo: retryCount` : The maximum number of retries. Defaults to 2.
-	`every: duration` : Wait time duration between retry attempts. By default don't wait.
- `backoffExponentiallyWithTimeSlot: duration` : Wait time duration between retry attempts determined by using the [exponential backoff algorithm](https://en.wikipedia.org/wiki/Exponential_backoff) with a `duration` time slot.
- `when: condition` : Evaluate the condition with the current execution result, if met retry the execution.
- `when: condition evaluating: action` : Like the previous one but `action` will be evaluated when a retry is made due to the condition. `action` is a block receiving as optional arguments the `attemptNumber` and the current `result`. For example:
```smalltalk
Retry
 value: [ "operation to execute" ]
 configuredBy: [:retry |
    retry
      when: [:result | result isError ]
      evaluating: [:attemptNumber :result | self log: ('Attempt #<1p> failed due to <2s>' expandMacrosWith: attemptNumber with: result errorDescription) ] ]
```
-	`on: exceptionSelector` : Retry the execution if an exception handled by `exceptionSelector` is raised.
- `on: exceptionSelector evaluating: action` : Like the previous one but `action` will be evaluated when a retry is made due to a handled exception raised. `action` is a block receiving as optional arguments the `attemptNumber` and the `exception` raised. For example:
```smalltalk
Retry
 value: [ "operation to execute" ]
 configuredBy: [:retry |
    retry
      on: NetworkError
      evaluating: [:attemptNumber :error | self log: ('Attempt #<1p> failed due to <2s>' expandMacrosWith: attemptNumber with: error messageText) ] ]
```
- `ignore: exceptionSelector` : Scope the previous method ignoring the exceptions that can be handled by `exceptionSelector`. For example:
```smalltalk
Retry
 value: [ "operation to execute" ]
 configuredBy: [:retry |
    retry
      on: NetworkError;
      ignore: ConnectionRefused ]
```
