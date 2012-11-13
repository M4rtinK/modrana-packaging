modRana packagign scripts
=========================

These scripts are used to produce modRana tarballs and installation packages.

How does it work
----------------
The __paskage.sh__ script is the main entry point for the packaging process. It manages the whole workflow and also sets the version number and changelog.

Workflow
--------
1. updates the source code in modrana-git from the corresponding Github repository
2. runns __modrana/setup.py__ with the _Fremantle_ and _Harmattan_ targets to create _Fremantle_ and _Harmattan_ source packages
3. uploads the source packages to OBS to build binary _Fremantle_ and _Harmattan_ packages (replaces the current in-OBS source package)
4. archives the tarballs (the source tarbals from the archive directory can be used for the _Maemo Fremantle autobuilder_)
5. cleanup

Atribution
----------
Uses sdist-maemo from Khertan - thanks a lot ! :)
