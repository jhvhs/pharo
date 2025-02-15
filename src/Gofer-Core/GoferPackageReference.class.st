"
A GoferPackageReference refers to the latest version of a Monticello package.
"
Class {
	#name : 'GoferPackageReference',
	#superclass : 'GoferReference',
	#category : 'Gofer-Core-References',
	#package : 'Gofer-Core',
	#tag : 'References'
}

{ #category : 'private' }
GoferPackageReference >> matches: aResolvedReference [

	^ self packageName = aResolvedReference packageName
]

{ #category : 'accessing' }
GoferPackageReference >> packageName [

	^ name
]
