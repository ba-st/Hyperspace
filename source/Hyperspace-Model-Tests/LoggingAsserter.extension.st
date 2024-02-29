Extension { #name : #LoggingAsserter }

{ #category : #'*Hyperspace-Model-Tests' }
LoggingAsserter >> assertLogRecordsMatchRegexes: regexExpressions [

	memoryLogger recordings with: regexExpressions do: [ :record :regexExpression |
		| regexWithTimestamp |

		regexWithTimestamp := '\d{4}-\d{2}-\d{2}T\d{2}\:\d{2}\:\d{2}\.\d+(\+|-)(\d+\:\d+) <1s>' expandMacrosWith:
			                      regexExpression.
		testCase assert: ( record printString matchesRegex: regexWithTimestamp )
			description:
			( '<1s> does not match <2s>' expandMacrosWith: record printString with: regexWithTimestamp )
		]
]
