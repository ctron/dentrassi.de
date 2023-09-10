---
id: 38
title: 'Reading Object Streams in OSGi'
date: '2010-03-02T18:56:26+01:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=38'
permalink: /2010/03/02/reading-object-streams-in-osgi/
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - default
fabulous-fluid-featured-image:
    - default
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
tags:
    - Eclipse
    - OSGi
---

Reading an object from an ObjectInputStream is easy. But using OSGi it can be a little bit more difficult. Due to the class loader system of OSGi the ObjectInputStream might not know the class that was stored. Assume you have a Bundle A, B and C. B provides the storing capabilities that stores objects somewhere and C provides the data object itself. Now if A tells B to store some object from C this will not be a problem, since the object class is attached to the object instance. But reading back the object will result in a ClassNotFoundException since B has no reference to C and therefore does not know any classes of C.

One solution of course would be to add a dependency from B to C. But that is probably not what you want. Another way would be using Eclipses “Buddy” policies workaround for problems like this. In this case the bundle B would declare itself capable of working with the buddy system and C would declare itself a “buddy of B”. This turns around the reference. While this is a possible way if you cannot change the logic in B (like existing third party libraries that have to be used) it also has some drawbacks. First of all you commit to using Eclipse/Equinox since this is not covered by OSGi. Also you still have to declare those dependencies from C to B.

On the other hand you can sub-class the ObjectInputStream and override “resolveClass” to let the bundle resolve the class instead of the “current” classloader. Passing the bundle A to that input stream you would have all the classes you need.

Check out the following sample implementation:

```

import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.ObjectStreamClass;

import org.osgi.framework.Bundle;

/**
 * An object input stream which loads its classes from the provided bundle.
 * @author Jens Reimann
 *
 */
public class BundleObjectInputStream extends ObjectInputStream
{
    private final Bundle bundle;

    public BundleObjectInputStream ( final InputStream in, final Bundle bundle ) throws IOException
    {
        super ( in );
        this.bundle = bundle;
    }

    @Override
    protected Class<?> resolveClass ( final ObjectStreamClass desc ) throws IOException, ClassNotFoundException
    {
        return this.bundle.loadClass ( desc.getName () );
    }

}


```