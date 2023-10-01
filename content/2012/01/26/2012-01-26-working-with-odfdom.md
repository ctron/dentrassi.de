---
id: 153
title: 'Working with ODFDOM'
date: '2012-01-26T15:46:24+01:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=153'
permalink: /2012/01/26/working-with-odfdom/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
---

While working a little bit with ODFDOM to automatically generate some documentation I found some tasks rather difficult to accomplish due to the fact that they were hardly documented. There is a lot of ODF documentation, but how to use it with ODFDOM is another story.

<!-- more -->

So first a list of documentation I found:

- [offical javadoc of ODFDOM](http://odfdom.odftoolkit.org/0.8.7/odfdom/apidocs/)
- [ODF Documentation hosted by ODFDOM](http://odfdom.odftoolkit.org/0.8.7/odfdom/apidocs/doc-files/OpenDocument-v1.2-cd05-part1.html)
- [ODFDOM samples](http://www.langintro.com/odfdom_tutorials/) (slightly out of date)

## Adding a new paragraph with a pre-defined style

To create a new paragraph with a style I used the following static function:

```java  
public static OdfTextParagraph newStyledParagraph ( final OdfTextDocument odt, final String style, final String content ) throws Exception {
  final OdfTextParagraph p;
  if ( content != null ) {
    p = odt.newParagraph ( content );
  } else {
    p = odt.newParagraph ();
  }
  p.setStyleName ( style );
  return p;
}
```

## Adding fields (like title and subtitle)

The following snippet will create a new paragraph

```java
OdfTextParagraph p;
p = OdfHelper.newStyledParagraph ( odt, “Title”, null );
p.newTextTitleElement ();

p = OdfHelper.newStyledParagraph ( odt, “Subtitle”, null );
p.newTextSubjectElement ();
```

## Creating a new paragraph style

The next snippet creates a new a new style called “Source Text” dereived from “Text Boby”. The `setFontFamily` method is a helper to set all font properties at once.

```java
protected void setFontFamily ( final OdfStyleBase style, final String value ) {
  style.setProperty ( OdfTextProperties.FontFamily, value );
  style.setProperty ( OdfTextProperties.FontFamilyAsian, value );
  style.setProperty ( OdfTextProperties.FontFamilyComplex, value );
}

private void createStyles ( final OdfTextDocument odt ) {
  final OdfOfficeStyles styles = odt.getOrCreateDocumentStyles ();

  final OdfStyle style = styles.newStyle ( “Source Text”, OdfStyleFamily.Paragraph );
  style.setStyleParentStyleNameAttribute ( “Text Body” );
  style.setProperty ( OdfParagraphProperties.Margin, “1cm” );
  style.setProperty ( OdfParagraphProperties.BackgroundColor, “#DDDDDD” );
  setFontFamily ( style, “Courier New” );
}
```

## Copy content from one to another ODF File

While most of the document I made was created some static part a the beginning was needed. Instead of creating it manually I created a new ODT File in LibreOffice and imported the content to the generated document.

The following snipped does that:  

```java
private void createStaticContent ( final OdfTextDocument odt, final File file ) throws Exception {
  // check if file is readable and is a file
  if ( !file.canRead () || !file.isFile () ) {
    return;
  }

  // Load the document to import

  final OdfTextDocument staticOdt = OdfTextDocument.loadDocument ( file );

  // Create a new text section which will receive the content. This is optional.
  // You could also load the content directly on the root of the document

  final TextSectionElement section = new TextSectionElement ( odt.getContentDom () );
  odt.getContentRoot ().appendChild ( section );
  section.setTextProtectedAttribute ( true );
  section.setTextNameAttribute ( “Static Content” ); //$NON-NLS-1$

  // iterate over all nodes
  final NodeList childNodes = staticOdt.getContentRoot ().getChildNodes ();
  for ( int i = 0; i < childNodes.getLength (); i++ ) {
    // clone node from source
    final Node newNode = childNodes.item ( i ).cloneNode ( true );
    // import to target DOM
    final Node adoptedNode = odt.getContentDom ().adoptNode ( newNode );
    // append to section
    section.appendChild ( adoptedNode );
  }
}
```

Since only content is imported the styles of the target document will be used for the content that was imported.
