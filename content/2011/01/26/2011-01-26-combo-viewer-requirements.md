---
id: 32
title: 'Combo viewer requirements'
date: '2011-01-26T18:47:17+01:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=32'
permalink: /2011/01/26/combo-viewer-requirements/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
taxonomies:
  categories:
    - Development
  tags:
    - Eclipse
    - Java
    - SWT
---

Today I tried to create a combo viewer in Eclipse with a different approach than the it seems the widgets was designed. I have an object which has to main properties an ID and a descriptive name. While this is nothing unusual following requirements seems to be:

<!-- more -->

The list of the combo box should show the label while the text input field of the combo box should show the id of the object. Using Eclipse Databinding this seems to be an impossible task (if you know a way please post it at [stackoverflow](http://stackoverflow.com/q/4802622/222044)).

I managed to work around this issue intercepting the selection event triggered by the list, converting the value myself and setting the text property of the combo box manually. This will then trigger the databinding stuff and everything after that hack works as usual.

```java  
widget.addSelectionListener ( new SelectionAdapter () {  
 @Override  
 public void widgetSelected ( final SelectionEvent e )  
 {  
   final ISelection selection = AbstractComboSelector.this.viewer.getSelection ();  
   if ( !selection.isEmpty () && selection instanceof IStructuredSelection ) {
     final IStructuredSelection sel = (IStructuredSelection)selection;  
     widget.setText ( convert ( sel.getFirstElement () ) );  
   } else {
     widget.setText ( "" );  
   }
 }  
});

this.dbc.bindValue ( WidgetProperties.text ().observe ( this.viewer.getControl () ), this.value );  
```

The only issue that is left is the fact that the up and down keys won’t work since there is no real selected object anymore. The selection will always the “null” but the text property of the widget is set.

Works for me ;-)
