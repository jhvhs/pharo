"
Rename a class but making sure that existing clients not in the system can be migrated later on:
The idea is that 
	the class A is renamed into Anew
	it gets a subclass A that is deprecated. 
	
This way client code using A will be able to load and get all the behavior of Anew. 


Usage:
transformation := (RBRenameAndDeprecateClassTransformation 
				rename: #DANode
				to: #DANodePresenter)
				transform. 
(ChangesBrowser changes: transformation model changes changes) open


"
Class {
	#name : 'RBRenameAndDeprecateClassTransformation',
	#superclass : 'RBCompositeTransformation',
	#instVars : [
		'className',
		'newClassName'
	],
	#category : 'Refactoring-Transformations-Model-Unused',
	#package : 'Refactoring-Transformations',
	#tag : 'Model-Unused'
}

{ #category : 'api' }
RBRenameAndDeprecateClassTransformation class >> model: aRBModel rename: aClassName [

	^ self new
		model: aRBModel;
		className: aClassName
		yourself
]

{ #category : 'api' }
RBRenameAndDeprecateClassTransformation class >> model: aRBModel rename: aClassName to: aNewClassName [

	^ self new
		model: aRBModel;
		className: aClassName
		newClassName: aNewClassName;
		yourself
]

{ #category : 'api' }
RBRenameAndDeprecateClassTransformation class >> rename: aClassName [

	^ self new
		className: aClassName
]

{ #category : 'api' }
RBRenameAndDeprecateClassTransformation class >> rename: aClassName to: aNewClassName [

	^ self new
		className: aClassName
		newClassName: aNewClassName
]

{ #category : 'preconditions' }
RBRenameAndDeprecateClassTransformation >> applicabilityPreconditions [

	| class |
	class := self model classNamed: className.
	^ { (RBClassesExistCondition new classes: { class }).
		 (RBClassesAreNotMetaClassCondition new classes: { class }).
		 (RBNameIsGlobalCondition new model: self model
			   className: newClassName) not.
	     (RBValidClassNameCondition new className: newClassName) }
]

{ #category : 'executing' }
RBRenameAndDeprecateClassTransformation >> buildTransformations [

	^ transformations ifNil: [
		transformations := OrderedCollection
			with: (RBRenameClassRefactoring
						model: self model
						rename: className to: newClassName)
			with: ((RBInsertNewClassTransformation
					   model: self model
						className: className)
						superclass: newClassName asSymbol;
						subclasses: #();
						packageName: (self model classNamed: className) packageName)
		with: (RBDeprecateClassTransformation
						model: self model
						className: className)]
]

{ #category : 'preconditions' }
RBRenameAndDeprecateClassTransformation >> checkPreconditions [ 

	self checkApplicabilityPreconditions 
]

{ #category : 'api' }
RBRenameAndDeprecateClassTransformation >> className: aClassName [

	className := aClassName asSymbol 
]

{ #category : 'api' }
RBRenameAndDeprecateClassTransformation >> className: aClassName newClassName: aNewClassName [

	className := aClassName asSymbol.
	newClassName := aNewClassName asSymbol 
]

{ #category : 'api' }
RBRenameAndDeprecateClassTransformation >> newClassName: aNewClassName [

	newClassName := aNewClassName asSymbol 
]

{ #category : 'printing' }
RBRenameAndDeprecateClassTransformation >> storeOn: aStream [

	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream
		nextPutAll: ' className ''';
		nextPutAll: className;
		nextPutAll: ''' newClassName: ''';
		nextPutAll: newClassName.
	aStream nextPut: $)
]

{ #category : 'private' }
RBRenameAndDeprecateClassTransformation >> tmpName [
	"return the hidden name of the subclass"

	^ (#TmpSubclass,className) asSymbol
]
