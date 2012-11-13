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

import os
import md5hash

class Changes(object):

    """
    """
    def __init__(self, ChangedBy,description,changes,files,category,repository, **kwargs):
      self.options = kwargs
      self.description = description
      self.changes=changes
      self.files=files
      self.category=category
      self.repository=repository
      self.ChangedBy=ChangedBy

    def getContent(self):
        """
        """
        content = ["%s: %s" % (k, v)
                   for k,v in self.options.iteritems()]                  
                   
        if self.description:
            description=self.description.replace("\n","\n ")
            content.append('Description: ')
            content.append('  %s' % description)

        if self.changes:
            # create version header
            name = self.options["Source"]
            version = self.options["Version"]
            urgency = self.options["Urgency"]
            header = "%s (%s); urgency=%s" % (name, version, urgency)
            # normalize change line formatting
            changes = self.changes
            changes = changes.replace("\n  ","\n   ")
            changes = "   %s" % changes
            # append changes to header
            changes = "%s\n.\n%s" % (header, changes)
            # append to the rest
            content.append('Changes:')
            content.append('%s' % changes)

        if self.ChangedBy:
            content.append("Changed-By: %s" % self.ChangedBy)

        content.append('Files:')

        for onefile in self.files:
            print onefile
            md5=md5hash.md5sum(onefile)
            size=os.stat(onefile).st_size.__str__()
            content.append(' ' + md5 + ' ' + size + ' ' + self.category +' '+self.repository+' '+os.path.basename(onefile))

        return "\n".join(content) + "\n\n"

