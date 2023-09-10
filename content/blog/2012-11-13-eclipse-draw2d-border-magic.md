---
id: 174
title: 'Eclipse Draw2D Border Magic'
date: '2012-11-13T12:47:03+01:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=174'
permalink: /2012/11/13/eclipse-draw2d-border-magic/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:187;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
---

While using Eclipse Draw2D I stumbled over some quite interesting behaviour on win32 using rectangles and scaling.

We have a scalable layer and added a rectangle. When the layer was actually scaling (so not 1.0) strange artifacts appeared on win32 platforms. Finally it turned out that it was a negative line size with the outline flag set to true. Which renders on Linux as if outline would be set to false. Yet interesting was that setting the lineSize to 0.0 (zero) while keeping the outline flag true causes a hairline to be drawn. So a line which is 1 pixel, independent of the scale factor.

| Settings | Screenshot |
|---|---|
| \[code language=”Java”\]   figure.setOutline ( false );   \[/code\] | ![](http://dentrassi.de/wp-content/uploads/line1s.png "line1s") |
| \[code language=”Java”\]   figure.setOutline ( true );   \[/code\] Which is the same as:   \[code language=”Java”\]   figure.setOutline ( true );   figure.setLineWidthFloat ( 1.0f );   \[/code\] | ![](http://dentrassi.de/wp-content/uploads/line2s.png "line1s") |
| \[code language=”Java”\]   figure.setOutline ( true );   figure.setLineWidthFloat ( 0.0f );   \[/code\] This is the actual hairline variant. | ![](http://dentrassi.de/wp-content/uploads/line3s.png "line1s") |
| \[code language=”Java”\]   figure.setOutline ( true );   figure.setLineWidthFloat ( 2.0f );   \[/code\] | ![](http://dentrassi.de/wp-content/uploads/line4s.png "line1s") |
| \[code language=”Java”\]   figure.setOutline ( true );   figure.setLineWidthFloat ( -1.0f );   \[/code\] Note the small artefacts at on the sides. These are invisible if run under Linux. | ![](http://dentrassi.de/wp-content/uploads/line5s.png "line1s") |

The full code to create the canvas was:

\[code language=”Java”\]  
ScalableLayeredPane pane = new ScalableLayeredPane();

Layer layer = new Layer();  
layer.setLayoutManager(new StackLayout());

pane.add ( layer );

Figure figure = new Figure ();  
figure.setLayoutManager(new XYLayout());  
figure.setBackgroundColor(Display.getDefault().getSystemColor(SWT.COLOR\_DARK\_GRAY));  
figure.setOpaque(true);

RectangleFigure r = new RectangleFigure();  
r.setBackgroundColor(Display.getDefault().getSystemColor(SWT.COLOR\_YELLOW));  
figure.add(r, new Rectangle(10,10,20,20));  
layer.add ( figure );

pane.setScale(4.0);  
r.setLineWidthFloat(0.0f);  
r.setOutline(true);  
\[/code\]