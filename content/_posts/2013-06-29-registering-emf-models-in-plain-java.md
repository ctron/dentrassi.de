---
id: 299
title: 'Registering EMF models in plain java'
date: '2013-06-29T15:28:44+02:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=299'
permalink: /2013/06/29/registering-emf-models-in-plain-java/
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
---

Using [Eclipse EMF/Ecore](http://www.eclipse.org/modeling/emf/?project=emf#emf "Eclipse EMF/ECore") models inside the Eclipse Platform is quite easy. Loading an XML/XMI serialized model file is only a matter of some lines of code. The most interesting thing about this is that the whole Eclipse platform can handle the registration of models and model factories for you. So instead of knowing what model type you are loading, it will be detected and the right model factory will be used for loading and creating your model instance. Even better is the fact that also derived model objects can be loaded that way.

Just image you are writing a model A and extend object in the model B. So you can create a model instance which contains objects from model A and B and just serialize it to XML. Loading it back will of course give you model objects of type A and B. Although initially only model A existed and B was an extension using derivation. For this to work the resource mechanism of EMF must need to know which namespace is handled by which resource package and factory. If you are running inside an Eclipse Platform this is easily done using the extension mechanism. And the “genmodel” file and generator will automatically create the correct code and “plugin.xml” for this setup.

The problems start when you are outside the Eclipse Platform and running in a plain Java application. The default way to go is by registering all EMF models somewhere before loading the serialized models:

```
public void setup () {
  MyModelPackage.eINSTANCE.eClass();
}

```

  
While this seems plain simple for many scenarious, it still brings in the need to register you model packages manually at some point. If you only have one model you may be fine with this. But imagine you have a large number of models or you want to allow derived models:

```
public void setup () {
  MyModelPackage.eINSTANCE.eClass();
  MyExtensionModelPackage.eINSTANCE.eClass();
}

```

The problem here is that you must know in advance what extension are there. If you want to allow you application to be extended in some way you did not define in the beginning, you are out of luck using the this simple way. The Eclipse Extension manager would handle this for you, but this is not an option for most plain Java applications.

But since Java 1.6 there is a way similar to the Eclipse extension points which can be used to achieve what the extension manager would do with EMF models. The [ServiceLoader](http://docs.oracle.com/javase/6/docs/api/java/util/ServiceLoader.html "ServiceLoader") mechanism allows one to find implementations for a provided interface in the current classpath. Although this has some limitation when the classpath contains “http” references, but on the local filesystem it works without any problems.

We simply define an interface “ModelInitializer” which will be the reference to all models that we want to load at a time:

```
package de.dentrassi.models;

public interface ModelInitializer {
  void initializeModel ();
}

```

Next we add an implemenation of this in each jar file which contains a model, or at least which should be in charge if registering the model:

```
package de.dentrassi.sample;

public class ModelInitializerImpl implements ModelInitializer {
  public void initializeModel () {
    MyModelPackage.eINSTANCE.eClass();
  }
}

```

If course we do need to do this also for the other model packages. It can be done in the same implementation or in a different one, depending on what you prefer.

Now the important step is to add a “service file” to the JAR file. So each “ModelInitializer” instance must be declared as a “Service” in order for the “ServiceLoader” to find it. In order to do this we need to add a file named “de.dentrassi.models.ModelInitializer” (or whatever you named your interface) and put in the class name of the implemenation. The file has to be placed in the “META-INF/services” directory of your JAR file:

```
de.dentrassi.sample.ModelInitializerImpl
```

Again, this has to be done for all implementations.

So when we want to initialize all model packages we can use the ServiceLoader in order to find all that are declared:

```
import de.dentrassi.models.ModelInitializer;
import java.util.ServiceLoader;

public void initializeAll () {
  ServiceLoader<ModelInitializer> serviceLoader = ServiceLoader.load(ModelInitializer.class);
  for (ModelInitializer service : serviceLoader) {
         service.initializeModel ();
  }
}

```

That’s it! What happens is that all declared instances if “ModelInitializer” will be located and their “initializeModel” method will be called, which then will initialize the EMF model and register it with the central registry. Also it is no problem if the initialization is run multiple times since the process of initialization will be correctly handled by EMF models in this case.

The layout of multiple JAR files would be like this:

```

fileModel.jar
  de/
    dentrassi/
      sample/
        ModelInitializerImpl.class
  META-INF/
    services/
      de.dentrassi.models.ModelInitializer -> Contains: "de.dentrassi.sample.ModelInitializerImpl"
fileModelExtension.jar
  de/
    dentrassi/
      ext/
        ModelInitializerImpl.class
  META-INF/
    services/
      de.dentrassi.models.ModelInitializer -> Contains: "de.dentrassi.ext.ModelInitializerImpl"
```