TArtPanel v2.6
==============



Introduction
------------
TArtPanel is an extended TPanel that offers full control over the text alignment (horz/vert)
and the colors of the bevels (highlight/shadow). It even allows you to specify 4 bitmaps, one
for each edge. The bitmaps can be displayed both transparent and opaque.



Changes
-------
Improved Delphi 5/6 compatibility
  * Modified for Delphi 6 compatibility
  * Added new properties 
  


License
-------
The component ist licensed under the MIT License. For details,
please refer to the LICENSE file.



Contents of the archive
-----------------------
    ARTPANEL.PAS     - Component source code.
    ARTPANEL.DCR     - Component resource.
    ARTPANELREG.PAS  - Component installation code.
    README.TXT       - This file.



Installation
------------
The basic installation of the component is pretty straight forward:
  1. Copy all files apart from README.TXT into the LIB folder or a subfolder
  2. Add the file ani95reg.pas to one of your design-time packages or create
     a new design-time package for the component as described in Delphi's help files.
  3. Recompile the design-time package

The more sophisticated installation takes a little more work:
  1. Copy all files apart from README.TXT into the LIB folder or a subfolder
  2. Create a new run-time package as described in Delphi's help files.
     If you are already using a run-time package for your components you can 
     use that package.
  3. Add the file ani95.pas to this run-time package and recompile the package.
  4. Create a new design-time package as described in Delphi's help files.
     If you are already using a design-time package for your components you can
     use that package.
  5. "Require" the run-time package you created or used above, if not already 
     the case (see Delphi help for details on "requiring packages").
  6. Add the file ani95reg.pas to the design-time package and recompile.



"DsgnIntf not found"
====================
If you get this error, something wrong happened during the installation. The unit
DsgnIntf is not shipped with Delphi 5/6 anymore, which previously provided classes for 
property/component editors. Now this unit is only included in one of Delphi's standard 
packages.

Thus, you must now make sure that run-time packages include only run-time code! If this
error occurs during the installation, you're trying to add the ani95reg.pas unit to a
run-time package, which is not allowed. In that case, use the ani95.pas unit instead and
create a special design-time package as described under "Installation".

