---
id: 325
title: 'EMF GenModel Annotations'
date: '2013-07-24T11:19:37+02:00'
author: 'Jens Reimann'
layout: page
guid: 'http://dentrassi.de/?page_id=325'
authorsure_hide_author_box:
    - ''
authorsure_include_css:
    - ''
---

A cheatsheet for EMF annotations which influence the code generation of GenModels.

## The “Gen” pattern

Although is has nothing to do with annotations, it is a powerful instrument during the generation process.

A method name can be suffixed with “Gen” and by that “moved out of the way”, but still be generated.

Assume you have a method that is generated an called “init”. You can rename the method to “initGen” and keep (!!) the “@generated” marker. This will let the generation tools still generate the method “init” but as “initGen”. The method “init” is missing then as has to be provided manually. But from this method you can call “initGen” and, to some degree, influence what happens.

See below for [an example](#sample_gen_pattern_1).

## http://www.eclipse.org/emf/2002/GenModel

### Common

| Name | Description |
|---|---|
| documentation | The documentation for this model element |
| copyright | Copyright information for this model element |

### Feature

| Name | Description |
|---|---|
| get | The code of the getter method. |
| suppressedGetVisibility | “true” or “false”. Suppres the creation of the getter for this feature. |
| suppressedSetVisibility | “true” or “false”. Suppress the creation of the setter for this feature. |
| suppressedIsSetVisibility | “true” or “false”. Suppress the creation of the isSet method for this feature. |
| suppressedUnsetVisibility | “true” or “false”. Suppress the creation of the unset method for this feature. |

### Operation

| Name | Description |
|---|---|
| body | The body contents used when generating the method for the operation. |

### DataType

| Name | Description |
|---|---|
| create | The body of the creator method. |
| convert | The body of the convertor method. |

## http://www.eclipse.org/emf/2002/Ecore

### All

| Name | Description |
|---|---|
| constraints | A whitespace delimited list of constraints.The constraint expression is then fetched from an annotation of the same model element. All validation delegates (URIs) are tried to load as annotation URI with the constraint name as value. So for example if a model element has “constraints=test1 test2” and the package has the “validationDelegates” value set to “urn:delegate1” then the annotation urn:delegate1#test1 and urn:delegate1#test2 will be loaded.  If there is no expression present it will create a dummy method in the Validator class with must be implemented by the user. And marked with “@genenreated NOT”. |

### Package

| Name | Description |
|---|---|
| validationDelegates | A whitespace separated list of validation delegate URIs.e.g. “urn:deletegate1 urn:delegate2” |

## Examples

### A “Gen” pattern example {#sample_gen_pattern_1}

\[code language=”java”\]  
/\*\*  
 \* …  
 \* @generated  
 \*/  
public static CommonPackage initGen () {  
 if ( isInited ) {  
 return (CommonPackage)EPackage.Registry.INSTANCE.getEPackage ( CommonPackage.eNS\_URI );  
 }

 final CommonPackageImpl theCommonPackage = (CommonPackageImpl) ( EPackage.Registry.INSTANCE.get ( eNS\_URI ) instanceof CommonPackageImpl ? EPackage.Registry.INSTANCE.get ( eNS\_URI ) : new CommonPackageImpl () );

 isInited = true;  
 WorldPackage.eINSTANCE.eClass ();  
 theCommonPackage.createPackageContents ();  
 theCommonPackage.initializePackageContents ();  
 theCommonPackage.freeze ();

 EPackage.Registry.INSTANCE.put ( CommonPackage.eNS\_URI, theCommonPackage );  
 return theCommonPackage;  
}

public static CommonPackage init () {  
 final CommonPackage result = initGen ();  
 EValidator.Registry.INSTANCE.put ( result, new ExtensibleValidationDescriptor () );  
 return result;  
}

\[/code\]
