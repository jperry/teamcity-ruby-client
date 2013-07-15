## 0.4.0 (Jun 15, 2013)

* Added ```pin_build``` and ```unpin_build``` (Provides the ability to pin and unpin a build respectively)
* Added ```build_statistics``` (Provides the ability to fetch build [statistics](http://confluence.jetbrains.com/display/TCD8/Custom+Chart#CustomChart-listOfDefaultStatisticValues))
* Added ```buildtype_investigations``` (Provides the ability to fetch build investigation details)

## 0.3.0 (May 23, 2013)

* Loosen up dependency requirement on the version of builder (Conflicted with transitive dependencies of rails 3.2.13)
* Added ```delete_buildtype``` to the API (Provides the ability to delete a build configuration)
* Added ```set_build_step_field``` to the API (Provides the ability to set a build step field, i.e. enable/disable a build step)

## 0.2.0 (May 7, 2013)

  - added support for httpAuth
  - added several CRUD methods to the api for BuildTypes, Projects, and VCSRoots
  - code cleanup

## 0.1.0 (April 28, 2013)

Features:

  - added GET support for projects
  - added GET support for build types (build configurations)
  - added GET support for builds
