Flink - Asset Packager
======================

	IMPORTANT: Library and documentation are still under heavy development. Changes in the API are very likely!

This library allows to load assets in an optimised way. Therefore assets get grouped and compressed in packages. For this step an Ant script is available.

**Use cases for this library:**

- Optimised asset loading due to reduced size and fewer requests
- Very high compression possible (using deflate)
- Obfuscates the data that you load (e.g. configurations)
- Automated optimisation during build process on CI server
- Caches assets for multiple requests
- Integrated fallback without packages (for local testing)
- Integrates with your existing asset loader lib*

*) Requires additional work, see **Usage** below

**What does it do?**

The main concept is to summarise assets in compressed packages. When loading a file the library checks in which package the asset is stored. After loading uncompressing and parsing the package, the asset data gets returned. It is best practise to use this approach only for release versions in order to not have to create packages whenever an asset changes. That's why the library internally determines wether to load packages or load the assets directly.

**Dependencies**

AS3-Signals

Usage
=====

Introduction
------------

* Create packages only for releases
* For local debugging/testing always load assets individually
* Create packages automatically on CI server
* Group assets based on their usage (group assets that are likely used at same time)
* Compress only contents that are not compressed already (don't compress SWFs)
* Mark files as cacheable if they will be used multiple times
* Be careful, requesting files, not marked as cacheable multiple times requires loading the whole package again
* Files not marked as cacheable will be removed after the first request

Creating the packages
---------------------

Using flink within Flash
------------------------

Change log
==========

Roadmap
=======
