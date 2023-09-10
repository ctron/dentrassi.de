---
id: 59
title: 'Access to WMI in Java using Eclipse SWT OLE integration'
date: '2011-02-04T17:58:44+01:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=59'
permalink: /2011/02/04/access-to-wmi-in-java-using-eclipse-swt-ole-integration/
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - default
fabulous-fluid-featured-image:
    - default
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:68;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
tags:
    - Eclipse
    - Java
    - SWT
    - Win32
---

Today I ran into a problem which could easily solved using a short WMI query. The problem was that the query must be executed within a Java UI application. Googling for a solution I came only up with either quite some ugly workarounds (like generating a VBScript fragment, forking off the VBScript runtime and parsing the result) or some full blown COM/DCOM interfaces (like J-Integra or J-Interop). Although I really like J-Interop (we are using it for DCOM when accessing OPC server in OpenSCADA Utgard) it has some drawbacks. For J-Interop every access (even local access) is a network based access. Since J-Interop only supports DCOM it is free of any platform specific code but required the machine to be accessible using “remoting” functionality (DCOM). Since I wanted to query the WMI from a UI application and I am sure that the WMI query will stay on the Win32 version of the application I was not keen on adding “remoting” as a requirement to the UI application.

After some digging I remembered that SWT brings an OLE interface which provides direct COM access. So I started poking around and finally come up with a solution that works quite well.

[![](https://dentrassi.de/wp-content/uploads/wmisample-150x150.png "wmisample")](https://dentrassi.de/wp-content/uploads/wmisample.png) For the impatient: The full source code is available from github <https://github.com/ctron/wmisample> and the screenshot is here.

The solution requires: win32 or win64, SWT and some classes from the SWT internal namespace. The latter is a catch that does not hurt too much.

First one needs a SWbemServices object which is obtained by asking the SWbemLocator to create one:

```
OleAutomation automation = new OleAutomation("WbemScripting.SWbemLocator");
Variant service = automation.invoke(Helper.getId(automation, "ConnectServer"));

```

The variant will hold a VT\_DISPATCH value which references the SWbemServices instance. Instead of calling the <q>ConnectServer</q> method with any parameters one can also call with full remote server support (see [MSDN](http://msdn.microsoft.com/en-us/library/aa393720%28v=VS.85%29.aspx)).

The next, and rather easy, step is to execute the query:

```
OleAutomation serviceAutomation = service.getAutomation();

Variant resultList = serviceAutomation.invoke(
   Helper.getId(serviceAutomation, "ExecQuery"),
   new Variant[] {
      new Variant(query),
      new Variant("WQL"),
      new Variant(32) });

```

The Helper.getId method fetches the dispatch id (function number) from the name of the function. So instead of calling a function by name you call it by id and look up the id by the name first:

```
public static int getId(OleAutomation auto, String name) {
   int result[] = auto.getIDsOfNames(new String[] { name });
   if (result == null || result.length < 1) {
      throw new RuntimeException(String.format(
         "Object does not support '%s'", name));
   }
   return result[0];
}

```

The result of the <q>ExecQuery</q> call is an object of the type <tt>SWbemObjectSet</tt>. The strange thing with this object is, that [by documentation](http://msdn.microsoft.com/en-us/library/aa393762%28v=VS.85%29.aspx) it only has an <q>Item</q> method which requires that you actually don’t want to know and provide. While all examples you find which that the result is directly used in VB <q>for each</q> constructs. But the object also provides an undocumented (still valid) <q>\_NewEnum</q> method which is used by e.g. VB by default for <q>for each</q> loops. So one can call this method explicitly and iterate over the result.

The problem here is, that the result to the <q>\_NewEnum</q> call is a VT\_UNKNOWN variant since the result is a COM object without support for IDispatch. So one has to play plain COM games and QueryInterface for IEnumVARIANT and iterate using <q>Next</q>.

And here comes the part were one needs to use SWT internal methods, since this requires allocating memory and performing pointer stuff. So be warned, from here on your are actually calling operating system memory allocating functions that may: a) crash your application when used improperly (like it does when you use C or C++) and b) produce memory leaks that are not covered by the Java VM but by direct calls to <q>alloc</q> calls in the OS.

In order to separate this stuff from the rest of the classes it all went into the Helper class, providing an <q>forEachVariant</q> method using a visitor interface:

```
public static interface VariantVisitor {
  public void visit(Variant variant);
}

```

The method first gets the <q>enum</q> using the property (not method) <q>\_NewEnum</q> which returns a variant of type VT\_UNKNOWN:

```
Variant enumObject = enumerableAuto.getProperty(
  Helper.getId(enumerableAuto, "_NewEnum")
);

```

Now one needs to QueryInterface to get the IEnumVARIANT interface for the unknown:

```
long /* int */[] ppvObject = new long /* int */[1];
int rc = enumObject.getUnknown().QueryInterface(COM.IIDIEnumVARIANT, ppvObject);
if (rc != OS.S_OK)
  return rc; // in case of error

```

Looks actually like call in C. The result will be a pointer to a IEnumVARIANT in ppvObject. You should also be aware of the fact that QueryInterface also performes an AddRef, so you have to perform one Release call when you are done in order to decrease the usage count on the instance.

Next one can pass the pointer to the instance to an instance of IEnumVARIANT (which is also from SWT internal) and already provides mapping to the function calls Reset, Next, Release.

```
IEnumVARIANT enumVariant = new IEnumVARIANT(ppvObject[0]);
enumVariant.Reset();

```

And now comes the <q>fun</q> part of the whole thing. Allocating memory and iterating over the enumeration:

```
int[] pceltFetched = new int[1];
long rgelt = OS.GlobalAlloc(OS.GMEM_FIXED | OS.GMEM_ZEROINIT,Variant.sizeof);

try {
  while (enumVariant.Next(1, rgelt, pceltFetched) == OLE.S_OK
    && pceltFetched[0] == 1) {
      Variant v = Variant.win32_new(rgelt);
      variantVisitor.visit(v);
   }
} finally {
    OS.GlobalFree(rgelt);
}

```

First a new Variant structure is allocated (again, this is OS memory allocation, not JVM!). Next the while loop iterates over the enumeration using Next calls and passes the variants to the visitor interface. The try-finally block ensures that when something goes wrong, at least the memory is freed in order to prevent memory leaks.

Actually is was asking myself why this IEnumVARIANT implementation does not perform the full magic and provides a way to access enums without using internal stuff. But I guess the SWT team has not too much interest in working on OLE/COM stuff and likes to keeps things as minimalistic as possible.

As last step the while executeQuery method iterates over the <q>SWbemObjectSet</q> enumeration which returns Variants (VT\_DISPATCH) pointing to instances of <q>SWbemObject</q>. They again have a property <q>Properties\_</q> that, which again is an enumeration of <q>Name</q> and <q>Value</q> pairs. The one needs to iterate again in order to request all properties.

it was quite interesting to see what is possible with Eclipse SWT and quite annoying to dig through incomplete COM documentation. But in the end it worked :)

Don’t forget to check the full source code at github: <https://github.com/ctron/wmisample>

Just clone (aka check out) the source:

```
git clone git://github.com/ctron/wmisample.git wmisample.git
```

If you don’t like to use git, you can also use the “Downloads” button on github and download a ZIP instead.

The full forEach method is:

```
public static int forEachVariant(Variant enumerable,
			VariantVisitor variantVisitor) {
		OleAutomation enumerableAuto = enumerable.getAutomation();

		try {
			Variant enumObject = enumerableAuto.getProperty(Helper.getId(
					enumerableAuto, "_NewEnum"));

			long /* int */[] ppvObject = new long /* int */[1];
			int rc = enumObject.getUnknown().QueryInterface(
					COM.IIDIEnumVARIANT, ppvObject);

			if (rc != OS.S_OK)
				return rc;

			IEnumVARIANT enumVariant = new IEnumVARIANT(ppvObject[0]);

			try {
				enumVariant.Reset();

				int[] pceltFetched = new int[1];

				long rgelt = OS.GlobalAlloc(OS.GMEM_FIXED | OS.GMEM_ZEROINIT,
						Variant.sizeof);

				try {
					while (enumVariant.Next(1, rgelt, pceltFetched) == OLE.S_OK
							&& pceltFetched[0] == 1) {
						Variant v = Variant.win32_new(rgelt);
						variantVisitor.visit(v);
					}
				} finally {
					OS.GlobalFree(rgelt);
				}
			} finally {
				enumVariant.Release();
			}

			return OLE.S_OK;

		} finally {
			enumerableAuto.dispose();
		}
	}

```

And the full query logic method is:

```
public List<WMIObjectInformation> executeQuery(String query) {
		OleAutomation serviceAutomation = service.getAutomation();
		try {
			final List<WMIObjectInformation> result = new LinkedList<WMIObjectInformation>();

			Variant resultList = serviceAutomation.invoke(
					Helper.getId(serviceAutomation, "ExecQuery"),
					new Variant[] { new Variant(query), new Variant("WQL"),
							new Variant(32) });

			if (resultList == null) {
				throw new RuntimeException(serviceAutomation.getLastError());
			}

			Helper.forEachVariant(resultList, new VariantVisitor() {

				@Override
				public void visit(Variant variant) {

					final Map<String, Object> params = new HashMap<String, Object>();

					Variant properties = Helper.getParameter(variant,
							"Properties_");

					Helper.forEachVariant(properties, new VariantVisitor() {

						@Override
						public void visit(Variant variant) {

							Variant name = Helper.getParameter(variant, "Name");
							Variant value = Helper.getParameter(variant,
									"Value");
							Object objectValue = Helper.convertVariant(value);

							params.put(name.getString(), objectValue);
						}
					});

					result.add(new WMIObjectInformation(Helper.getParameter(
							Helper.getParameter(variant, "Path_"), "Path")
							.getString(), params));
				}
			});

			return result;
		} finally {
			serviceAutomation.dispose();
		}
	}

```