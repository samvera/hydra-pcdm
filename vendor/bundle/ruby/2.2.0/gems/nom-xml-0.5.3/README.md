# nom-xml

[![Build Status](https://secure.travis-ci.org/cbeer/nom.png)](http://travis-ci.org/cbeer/nom)

A library to help you tame sprawling XML schemas.

nom-xml allows you to define a “terminology” to ease translation between XML and ruby objects – you can query the xml for Nodes or node values without ever writing a line of XPath. nom-xml is built on top of [nokogiri](http://nokogiri.org) decorators, which means you can mix-and-match NOM accessors with nokogiri xpaths, xml manipulation, and traversing and it will just work.


Some Handy Links
----------------
Here are some resources to help you learn more about nom-xml:

- [API](http://rubydoc.info/github/cbeer/nom-xml) - A reference to nom-xml's classes
- [#projecthydra](http://webchat.freenode.net/?channels=#projecthydra) on irc.freenode.net
- [Project Hydra Google Group](http://groups.google.com/group/hydra-tech) - community mailing list and forum

An Example
---------------

```xml
<?xml version="1.0"?>
<!-- from http://www.alistapart.com/d/usingxml/xml_uses_a.html -->
<nutrition>
<food>
	<name>Avocado Dip</name>
	<mfr>Sunnydale</mfr>
	<serving units="g">29</serving>
	<calories total="110" fat="100"/>
	<total-fat>11</total-fat>
	<saturated-fat>3</saturated-fat>
	<cholesterol>5</cholesterol>
	<sodium>210</sodium>
	<carb>2</carb>
	<fiber>0</fiber>
	<protein>1</protein>
	<vitamins>
		<a>0</a>
		<c>0</c>
	</vitamins>
	<minerals>
		<ca>0</ca>
		<fe>0</fe>
	</minerals>
</food>
</nutrition>
```

```ruby
require 'nom/xml'

# load the source document as normal
doc = Nokogiri::XML my_source_document

doc.set_terminology do |t|
  t.name

  t.vitamins do |v|
    v.a
    v.c
  end

  t.minerals do |m|
    m.calcium :path => 'ca'
    m.iron :path => 'fe'
  end
end

doc.nom!

doc.name.text == 'Avocado Dip'
doc.minerals.calcium.text == '0'
```



