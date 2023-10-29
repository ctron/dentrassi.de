---
id: 169
title: 'Setting the page size and orientation with ODFDOM for tables aka spreadsheets'
date: '2012-08-27T17:36:27+02:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=169'
permalink: /2012/08/27/setting-the-page-size-and-orientation-with-odfdom-for-tables-aka-spreadsheets/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
taxonomies:
  categories:
    - Development
  tags:
    - ODF
---

Most tasks that seem to be quite easy tend to turn out as a disaster. Setting the page size and orientation with ODFDOM was such a thing. While styling with ODFDOM is powerful and a horror at the same time. You actually never know where the attribute has to be placed or which attributes to use.

<!-- more -->

After I finished an export to “ods” (aka spreadsheet), it simply wanted to set the format to “A4 landscape”. Here is how to do that:

First create your spreadsheet and sheet (you might already have done that):

```java
OdfSpreadsheetDocument output = OdfSpreadsheetDocument.newSpreadsheetDocument ();
final OdfTable sheet = OdfTable.newTable ( output );
```

Now change the styles to “A4 landscape”:

First, we need to get the “master page” named “Default”:  
```java
StyleMasterPageElement defaultPage = output.getOfficeMasterStyles ().getMasterPage ( “Default” );
```

The master page tells us the name of the page style:  
```java
String pageLayoutName = defaultPage.getStylePageLayoutNameAttribute ();  
```

Which gives us the page layout object:  
```java  
OdfStylePageLayout pageLayout = defaultPage.getAutomaticStyles ().getPageLayout ( pageLayoutName );  
```

Finally, we can set “A4 landscape”:

```java  
pageLayout.setProperty ( OdfPageLayoutProperties.PrintOrientation, "landscape" );  
pageLayout.setProperty ( OdfPageLayoutProperties.PageHeight, "210.01mm" );  
pageLayout.setProperty ( OdfPageLayoutProperties.PageWidth, "297mm" );  
pageLayout.setProperty ( OdfPageLayoutProperties.NumFormat, "1" );  
```

All four properties seem to be required. Also, the width and height have to be rotated according to “landscape”.
