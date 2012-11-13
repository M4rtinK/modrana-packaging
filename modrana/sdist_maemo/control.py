#
# sdist_maemo
#
# Script to add 'sdist_maemo' source package distribution command to
# 'distutils'. This command builds '.dsc, .changes, .tar.gz' packages suitable for installation
# on the Maemo platform by the Maemo autobuilder or the community obs.
#
# Author: khertan@khertan.net
# License: GPL 3.0
#
# (Based on standard Python-supplied 'command_template' file.)

'''Generate the control content'''

import os
import sys

class Control:
    def __init__(self,name,section,maintainer,email,arch,
                    depends,build_depends,suggests,description,long_description,
                    conflicts,
                    replaces,
                    standardsVersion,
                    optionnal = {}):

#TODO: handle build-depends correctly
        self.control="""Source: %(name)s
Section: %(section)s
Priority: optional
Maintainer: %(maintainer)s <%(email)s>
Build-Depends: %(build-depends)s
Standards-Version: %(standards)s

Package: %(name)s
Architecture: %(arch)s""" % {'name':name,
                    'section':section,
                    'maintainer':maintainer,
                    'email':email,
                    'arch':arch,
                    'standards':standardsVersion,
                    'build-depends':build_depends
        }

        if depends:
            self.control = self.control + '\nDepends: %s' % depends
        if suggests:
            self.control = self.control + '\nSuggests: %s' % suggests
        if conflicts:
            self.control = self.control + '\nConflicts: %s' % conflicts
        if replaces:
            self.control = self.control + '\nReplaces: %s' % replaces
        if description:
            self.control = self.control + '\nDescription: \n %s ' % description

        for key in optionnal:
            if key and optionnal[key]:
                self.control = self.control + '\n%s: %s' % (key, optionnal[key])

    def getContent(self):
        print self.control
        return self.control

