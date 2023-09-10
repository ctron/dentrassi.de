---
id: 94
title: 'Fancy tooltips in Eclipse'
date: '2011-02-21T12:34:39+01:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=94'
permalink: /2011/02/21/fancy-tooltips-in-eclipse/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:100;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
tags:
    - Eclipse
    - Java
    - JFace
    - SWT
---

Tooltips are quick way to add information to a widget that received the users attention. While one can argue about the pros and cons of tooltips this post focuses on the style of tooltips once you decided to use them.

A default use case is to add a description to e.g. an icon based button:

[![](http://dentrassi.de/wp-content/uploads/tooltip_native_short.png "tooltip_native_short")](http://dentrassi.de/wp-content/uploads/tooltip_native_short.png)

Now and then you might find yourself in the need to add some more information than just a short text. While I think the upper example is a good example for using a tooltip the following is now really:

[![](http://dentrassi.de/wp-content/uploads/tooltip_native_long.png "tooltip_native_long")](http://dentrassi.de/wp-content/uploads/tooltip_native_long.png)

The problem is not necessarily the amount of information but the way it is presented. So why is it used? Because it is quite easy to use with SWT. The following line of code sets the tooltip text:

\[sourcecode language=”Java”\]  
Button button = …  
button.setToolTipText ( "Read descriptor: " + readDescriptor + "\\nWrite descriptor: " + writeDescriptor );  
\[/sourcecode\]

This call is using the widget toolkit’s own way to activate and render the tooltip. On the pro side you have the native look and feel and the quick way to add it, on the con side it only looks good when you have short and compact tooltips. Also you might run into problems with different behaviors on different platforms.

But Eclipse would not be Eclipse if there wasn’t a second way to add tooltips to you user interface. In JFace you will find a [ToolTip](http://help.eclipse.org/helios/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/jface/window/ToolTip.html "ToolTip") class which is the base for custom made tooltips. Using <tt>[DefaultToolTip](http://help.eclipse.org/helios/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/jface/window/DefaultToolTip.html) you have a working base that provides a plain implementation quite similar in the rendering as the native tooltip:</tt>

[![](http://dentrassi.de/wp-content/uploads/tooltip_jface_default.png "tooltip_jface_default")](http://dentrassi.de/wp-content/uploads/tooltip_jface_default.png)

Adding this a bit more complex but also provides some more options:

\[sourcecode language=”java”\]  
DefaultToolTip toolTip = new DefaultToolTip ( widget );  
toolTip.setShift ( new Point ( 5, 5 ) );  
toolTip.setText ( "Hello World" );  
\[/sourcecode\]

Browsing through the setters of the class you will find a lot to customize. On the con side, as you can see in the screenshot, it look like the native tooltip, but not exactly.

Now if this is still not enough customizing you can also dereive directly from <tt>org.eclipse.jface.window.ToolTip</tt> and implement <tt>createToolTipContentArea</tt> yourself:

\[sourcecode language=”java”\]  
protected Composite createToolTipContentArea ( final Event event, final Composite parent )  
{  
 …  
}  
\[/sourcecode\]

In our case we created a tooltip containing a header, an icon and a styled text:  
[![](http://dentrassi.de/wp-content/uploads/tooltip_jface_custom.png "tooltip_jface_custom")](http://dentrassi.de/wp-content/uploads/tooltip_jface_custom.png)

The pros and cons should be obvious.

But … there is one more thing. Eclipse would not be Eclipse if there would not be another way to do it (I know I repeat myself here). SWT also provides another [ToolTip](http://help.eclipse.org/helios/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/widgets/ToolTip.html) class. This class provides tooltips and “balloons”:

[![](http://dentrassi.de/wp-content/uploads/tooltip_swt_balloon.png "tooltip_swt_balloon")](http://dentrassi.de/wp-content/uploads/tooltip_swt_balloon.png)

The problem with these tooltips is, that they seem to be made for the Tray that can pop up balloons (see [Snippet](http://dev.eclipse.org/viewcvs/viewvc.cgi/org.eclipse.swt.snippets/src/org/eclipse/swt/snippets/Snippet225.java?view=co)). You still can position the tooltip manually and align it to you control, but I would guess that using JFace is a much cleaner approach.