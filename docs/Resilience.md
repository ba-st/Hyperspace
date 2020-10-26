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

The block to be evaluated can optionally receive the current number of attempt in a block argument. 

### Configuration Options
This options are sent to the `retry` instance provided in the second block.

-	`upTo: retryCount` : The maximum number of retries. Defaults to 2.
-	`every: duration` : Wait a time duration between retry attempts. By default don't wait.
- `backoffExponentiallyWithTimeSlot: duration` : Wait a time duration between retry attempts determined by using the [exponential backoff algorithm](https://en.wikipedia.org/wiki/Exponential_backoff) with a `duration` time slot.
- `when: condition` : Evaluate the condition with the current execution result, if met retry the execution.
- `when: condition evaluating: action` : Like the previous one but `action` will be evaluated when a retry is made due to the condition. `action` is a block receiving as optional arguments the `attemptNumber` and the current `result`.
-	`on: exceptionSelector` : Retry the execution if an exception handled by `exceptionSelector` is raised.
- `on: exceptionSelector evaluating: action` : Like the previous one but `action` will be evaluated when a retry is made due to a handled exception raised. `action` is a block receiving as optional arguments the `attemptNumber` and the `exception` raised.
- `ignore: exceptionSelector` : Scope the previous method ignoring the exceptions that can be handled by `exceptionSelector`.
