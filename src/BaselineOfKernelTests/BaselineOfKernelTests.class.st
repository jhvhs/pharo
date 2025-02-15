Class {
	#name : 'BaselineOfKernelTests',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfKernelTests',
	#package : 'BaselineOfKernelTests'
}

{ #category : 'baselines' }
BaselineOfKernelTests >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec 
			package: 	'CodeImport-Tests'	; 

			package: 	'Collections-Abstract-Tests';					
			package: 	'Collections-Atomic-Tests';
			package: 'Collections-Native-Tests';	
			package:	'Collections-Sequenceable-Tests';
			package: 	'Collections-Stack-Tests';	
			package: 	'Collections-Streams-Tests';		
			package: 	'Collections-Strings-Tests';	
			package: 	'Collections-Support-Tests';								
			package: 	'Collections-Unordered-Tests';
			package: 	'Collections-Weak-Tests' with: [ spec requires: #('Collections-Unordered-Tests') ];					
			package: 	'Collections-Tests' with: [ spec requires: #('Collections-Abstract-Tests' 'Collections-Atomic-Tests' 'Collections-Native-Tests' 'Collections-Sequenceable-Tests'  
					   'Collections-Streams-Tests' 'Collections-Strings-Tests' 'Collections-Support-Tests' 'Collections-Stack-Tests' 'Collections-Weak-Tests') ];
			package: 	'Kernel-Tests'; 
			package: 	'Kernel-Tests-Extended' ;
			package: 	'Kernel-Tests-WithCompiler';
			package: 	'Announcements-Core-Tests';
			package: 	'Compression-Tests'; 
			package: 	'FileSystem-Core-Tests' with: [ spec requires: #('Collections-Tests') ];
			package: 	'FileSystem-Disk-Tests';
			package: 	'FileSystem-Tests-Attributes';
			package: 	'Files-Tests' ;
			package: 	'Jobs-Tests' ;
			package: 	'AST-Core-Tests';
			package: 	'OpalCompiler-Tests' with: [ spec requires: #('AST-Core-Tests') ];
			package: 	'Random-Tests';
			package: 	'Ring-Definitions-Core-Tests';
			package: 	'Ring-Definitions-Tests-Containers'; 
			package: 	'System-Object Events-Tests';
			package: 	'System-OSEnvironments-Tests';
			package: 	'Zinc-Character-Encoding-Tests' ;
			package: 	'System-Platforms-Tests';
			package: 'System-Finalization-Tests';
			package: 	'Text-Tests' ]
]
