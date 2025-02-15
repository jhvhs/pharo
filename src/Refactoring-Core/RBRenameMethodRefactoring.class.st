"
I am a refactoring operation for renaming methods.

The new method name has to have the same number of arguments, but the order of arguments can be changed.

My preconditions verify that the number of arguments is the same and that the new method name isn't already used.

All references in senders of the old method are changed, either the method name only or the order of the supplied arguments.

Example
--------
There are two ways to rename a method, one of them is rename all senders of method:
```
(RBRenameMethodRefactoring 
		renameMethod: ('check', 'Class:') asSymbol
		in: RBBasicLintRuleTestData
		to: #checkClass1:
		permutation: (1 to: 1)) execute.
```
And the other is rename the method only in specific packages:
```
|refactoring|
refactoring :=RBRenameMethodRefactoring 
		renameMethod: ('check', 'Class:') asSymbol
		in: RBBasicLintRuleTestData
		to: #checkClass1:
		permutation: (1 to: 1).
refactoring searchInPackages:  #(#'Refactoring-Tests-Core').
refactoring execute
```
"
Class {
	#name : 'RBRenameMethodRefactoring',
	#superclass : 'RBChangeMethodNameRefactoring',
	#instVars : [
		'hasPermutedArguments'
	],
	#category : 'Refactoring-Core-Refactorings',
	#package : 'Refactoring-Core',
	#tag : 'Refactorings'
}

{ #category : 'instance creation' }
RBRenameMethodRefactoring class >> model: aRBSmalltalk renameMethod: aSelector in: aClass to: newSelector permutation: aMap [
	^ self new
		model: aRBSmalltalk;
		renameMethod: aSelector
			in: aClass
			to: newSelector
			permutation: aMap;
		yourself
]

{ #category : 'instance creation' }
RBRenameMethodRefactoring class >> renameMethod: aSelector in: aClass to: newSelector permutation: aMap [
	^ self new
		renameMethod: aSelector
		in: aClass
		to: newSelector
		permutation: aMap
]

{ #category : 'preconditions' }
RBRenameMethodRefactoring >> applicabilityPreconditions [

	^ self newNameDoesNotRequireRefactoringPreconditions not & (RBCondition
		   withBlock: [ oldSelector numArgs = newSelector numArgs ]
		   errorString: newSelector printString
			   , ' doesn''t have the correct number of arguments.')
]

{ #category : 'preconditions' }
RBRenameMethodRefactoring >> breakingChangePreconditions [

	^ self doesNotOverrideExistingMethodPrecondition 
]

{ #category : 'preconditions' }
RBRenameMethodRefactoring >> generateChanges [
	"Prepare, check the preconditions, and perform the actual transformation (i.e., creating a list of changes that can be accessible using the changes message). This method should not be invoked from drivers since drivers usually check in finer grained mode the preconditions - and that this stage they already checked the preconditions."
	
	self prepareForExecution.

	self applicabilityPreconditions check ifFalse: [
		^ RBApplicabilityChecksFailedError signal:
			  self applicabilityPreconditions errorString ].
	self breakingChangePreconditions check ifFalse: [
		RBBreakingChangeChecksFailedWarning signal:
			self breakingChangePreconditions errorString ].

	self privateTransform.
	^ self changes
]

{ #category : 'testing' }
RBRenameMethodRefactoring >> hasPermutedArguments [

	^ hasPermutedArguments
		ifNil: [ hasPermutedArguments := super hasPermutedArguments ]
		ifNotNil: [ hasPermutedArguments ]
]

{ #category : 'testing' }
RBRenameMethodRefactoring >> implementorsCanBePrimitives [
	^self hasPermutedArguments not
]

{ #category : 'private' }
RBRenameMethodRefactoring >> modifyImplementorParseTree: parseTree in: aClass [
	super modifyImplementorParseTree: parseTree in: aClass.
	self renameArgumentsIn: parseTree
]

{ #category : 'preconditions' }
RBRenameMethodRefactoring >> myConditions [
	^RBCondition withBlock: [oldSelector numArgs = newSelector numArgs]
		errorString: newSelector printString
				, ' doesn''t have the correct number of arguments.'
]

{ #category : 'preconditions' }
RBRenameMethodRefactoring >> newNameDoesNotRequireRefactoringPreconditions [
	"this could be part of skippingRefactoringPrecondition meaning that there is no need to execute it."


	^ (RBCondition
		   withBlock: [ newSelector = oldSelector ]
		   errorString:
		   'The selector name has <1?not:> changed <1?:to #' , newSelector
		   , '>') & (RBCondition
		   withBlock: [
		   permutation asArray = (1 to: oldSelector numArgs) asArray ]
		   errorString: 'The arguments are <1?:not >permuted')
]

{ #category : 'parsing' }
RBRenameMethodRefactoring >> parseTreeRewriterInstance [

	^ self hasPermutedArguments
		  ifTrue: [ self parseTreeRewriterClass new ]
		  ifFalse: [
			  self parseTreeRewriterClass
				  replaceLiteral: oldSelector
				  with: newSelector ]
]

{ #category : 'preconditions' }
RBRenameMethodRefactoring >> preconditions [

	^ self newNameDoesNotRequireRefactoringPreconditions | super preconditions
]

{ #category : 'accessing' }
RBRenameMethodRefactoring >> refactoredClass [
	^ class
]

{ #category : 'printing' }
RBRenameMethodRefactoring >> storeOn: aStream [
	aStream nextPut: $(.
	aStream nextPutAll: self class name.
	aStream
		nextPutAll: ' renameMethod: #';
		nextPutAll: oldSelector;
		nextPutAll: ' in: '.
	aStream nextPutAll: class name.	
	aStream
		nextPutAll: ' to: #';
		nextPutAll: newSelector;
		nextPutAll: ' permutation: '.
	permutation storeOn: aStream.
	aStream nextPut: $)
]
