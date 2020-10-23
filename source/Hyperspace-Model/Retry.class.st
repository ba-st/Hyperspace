"
I'm one of the resilience operations. I repeat failed executions a number of times.

Why I should use it?
Many faults are transient and may self-correct after a short time. So this helps in auto-recovery of transient errors.

## Configuration Options
- `#upTo: retryCount` : The maximum number of retries. Defaults to 2.
- `#every: duration` : Wait a time duration between retry attempts. By default don't wait.
- `#when: condition` : Evaluate the condition with the current execution result, if met retry the execution.
- `#on: exceptionSelector` : Retry the execution if an exception handled by `exceptionSelector` is raised.
- `#ignore: exceptionSelector` : Scope the previous method ignoring the exceptions that can be handled by `exceptionSelector`.

## Usage

```language=Pharo
Retry 
	value: [ ""operation to execute"" ]
	configuredBy: [:retry | ""configuration options"" ]
```


"
Class {
	#name : #Retry,
	#superclass : #Object,
	#instVars : [
		'exceptionsToRetry',
		'maximumNumberOfAttempts',
		'waitActionBetweenRetries',
		'exceptionsToIgnore',
		'retryCondition'
	],
	#category : #'Hyperspace-Model-Resilience'
}

{ #category : #'instance creation' }
Retry class >> configuredBy: configurationAction [

	^ self new initializeConfiguredBy: configurationAction
]

{ #category : #accessing }
Retry class >> defaultMaximumNumberOfAttempts [

	^ 3
]

{ #category : #evaluating }
Retry class >> value: aNyladicClosure [

	^ self value: aNyladicClosure configuredBy: [ :retry | retry onException ]
]

{ #category : #evaluating }
Retry class >> value: aNiladycBlock configuredBy: configurationAction [

	^ ( self configuredBy: configurationAction ) value: aNiladycBlock
]

{ #category : #configuring }
Retry >> every: aDuration [

	waitActionBetweenRetries := [ aDuration wait ]
]

{ #category : #configuring }
Retry >> ignore: anException [

	exceptionsToIgnore := exceptionsToIgnore , anException
]

{ #category : #initialization }
Retry >> initializeConfiguredBy: configurationAction [

	maximumNumberOfAttempts := self class defaultMaximumNumberOfAttempts.
	waitActionBetweenRetries := [  ].
	exceptionsToRetry := ExceptionSet new.
	exceptionsToIgnore := ExceptionSet new.
	self when: [ :result | false ].
	configurationAction value: self
]

{ #category : #configuring }
Retry >> on: anException [

	exceptionsToRetry := exceptionsToRetry , anException
]

{ #category : #configuring }
Retry >> onException [

	self on: Exception
]

{ #category : #configuring }
Retry >> upTo: aRetryCount [

	AssertionChecker enforce: [ aRetryCount strictlyPositive ]
		because: 'The maximum number of retries must be strictly positive.'.
	maximumNumberOfAttempts := aRetryCount + 1
]

{ #category : #configuring }
Retry >> upTo: aRetryCount timesEvery: aDuration [

	self
		upTo: aRetryCount;
		every: aDuration
]

{ #category : #evaluating }
Retry >> value: aNyladicBlock [

	1 to: maximumNumberOfAttempts - 1 do: [ :tryCount | 
		[ | result |
			result := aNyladicBlock value.
			[ ^ result ] unless: ( retryCondition value: result )
		] on: exceptionsToRetry 
		  except: exceptionsToIgnore 
		  do: [ :exception | exception return ].
		waitActionBetweenRetries cull: tryCount
		].

	^ aNyladicBlock value
]

{ #category : #configuring }
Retry >> when: aCondition [

	retryCondition := aCondition
]
