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
taxonomies:
  categories:
    - Development
  tags:
    - Eclipse
    - Draw2D
---

While using Eclipse Draw2D, I stumbled over some quite interesting behavior on win32 using rectangles and scaling.

<!-- more -->

We have a scalable layer and added a rectangle. When the layer was actually scaling (so not 1.0) strange artifacts appeared on win32 platforms. Finally it turned out that it was a negative line size with the outline flag set to true. Which renders on Linux as if outline would be set to false. Yet interesting was that setting the lineSize to 0.0 (zero) while keeping the outline flag true causes a hairline to be drawn. So a line which is 1 pixel, independent of the scale factor.

<table class="table">

<tr><th>Settings</th><th>Screenshot</th></tr>

<!--  row 1 -->

<tr><td>

```java
figure.setOutline ( false );
```
</td><td>

![](/wp-content/uploads/line1s.png "line1s")

</td></tr>

<!--  row 2 -->

<tr><td>

```java
figure.setOutline ( true );
```

Which is the same as:

```java
figure.setOutline ( true );
figure.setLineWidthFloat ( 1.0f );
```

</td><td>

![](/wp-content/uploads/line2s.png "line2s")

</td></tr>

<!--  row 3 -->

<tr><td>

```java
figure.setOutline ( true );
figure.setLineWidthFloat ( 0.0f );
```

This is the actual hairline variant.

</td><td>

![](/wp-content/uploads/line3s.png "line3s")

</td></tr>

<!--  row 4 -->

<tr><td>

```java
figure.setOutline ( true );
figure.setLineWidthFloat ( 2.0f );
```

</td><td>

![](/wp-content/uploads/line4s.png "line4s")

</td></tr>

<!--  row 5 -->

<tr><td>

```java
figure.setOutline ( true );
figure.setLineWidthFloat ( -1.0f );
```

Note the small artefacts at on the sides. These are invisible if run under Linux.

</td><td>

![](/wp-content/uploads/line5s.png "line5s")

</td></tr>

</table>

The full code to create the canvas was:

```java
ScalableLayeredPane pane = new ScalableLayeredPane();

Layer layer = new Layer();
layer.setLayoutManager(new StackLayout());

pane.add ( layer );

Figure figure = new Figure ();
figure.setLayoutManager(new XYLayout());
figure.setBackgroundColor(Display.getDefault().getSystemColor(SWT.COLOR_DARK_GRAY));
figure.setOpaque(true);

RectangleFigure r = new RectangleFigure();
r.setBackgroundColor(Display.getDefault().getSystemColor(SWT.COLOR_YELLOW));
figure.add(r, new Rectangle(10,10,20,20));
layer.add ( figure );

pane.setScale(4.0);
r.setLineWidthFloat(0.0f);
r.setOutline(true);
```
