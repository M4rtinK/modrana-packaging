#!/usr/bin/env python
# -*- coding: utf-8 -*-
##
##    Copyright (C) 2007 Khertan khertan@khertan.net
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published
## by the Free Software Foundation; version 2 only.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.

## modified by Martin Kolman for usage with sdist_maemo

import os
from os.path import curdir, sep, pardir, join, abspath, commonprefix

def relpath(path, start=curdir):
    """Return a relative version of a path"""
    if not path:
        raise ValueError("no path specified")
    start_list = abspath(start).split(sep)
    path_list = abspath(path).split(sep)
    # Work out how much of the filepath is shared by start and path.
    i = len(commonprefix([start_list, path_list]))
    rel_list = [pardir] * (len(start_list)-i) + path_list[i:]
    if not rel_list:
       return curdir
    return join(*rel_list)

class SpecFile(object):

    def __init__(self, main_command, origin):
        self.main_command = main_command
        self.package_name = main_command.debian_package
        self.origin_dir = origin

        files = []
        for root, dirs, fs in os.walk(self.origin_dir):
            fpath = relpath(root,self.origin_dir)
            for f in fs:
                # make a line RULES to be sure the destination folder is created
                # and one for copying the file
                #print root,dirs,f
                #print fpath

                files.append((
                  os.path.join(self.package_name,fpath,f),
                  os.path.join("/", fpath,f))
                )

        self.__files = files
        self.options = {
            'name' : main_command.name,
            'version' : main_command.version,
            'buildversion' : main_command.buildversion,
            'summary' : main_command.description,
            'section' : main_command.section,
            'license' : main_command.copyright,
            'url' : main_command.url, #TODO: get this from setup.py
            'sources' : main_command.tarball_filename,
            'builddepends' : main_command.build_depends,
            'depends' : main_command.depends,
            'description' : main_command.long_description,
            'preinst' : main_command.preinst,
            'postinst' : main_command.postinst,
            'prerm' : main_command.prere,
            'postrm' : main_command.postre,
            'changeslog' : main_command.changelog,
        }

    def _getContent(self):
        rules = []
        files = []
        for path, dest_path in self.__files:
            # local path to the files
            # (save the path without the build prefix as that is what will be
            # visible once the tarball is unpacked)
            build_path = os.path.join('build', path)
            if os.path.isfile(build_path): # it's a file
                dst_file_path = "%{buildroot}" + dest_path
                dst_dir = "%{buildroot}" + os.path.dirname(dest_path)
                files.append(dest_path)
                rules.append('mkdir -p "%s"' % dst_dir)

                # make a line RULES to be sure the destination folder
                # is created and one for copying the file
                rules.append('cp -a "%s" "%s"' %
                            (path, dst_file_path))

            elif os.path.isdir(build_path): # just create an (empty?) folder
              rules.append('mkdir -p "%s"' % path)
            else:
              print('error, unsupported path:\n%s' % path)

        self.options['specrules'] = '\n'.join(rules)
        self.options['packedfiles'] = '\n'.join(files)

        content = """
# due to the current inclusion of monav-server binaries,
# handle binaries in the otherwise noarch package
%%define debug_package %%{nil}
%%define _binaries_in_noarch_packages_terminate_build   0
# handle *.pyc & *.pyo unpackaged files
# TODO: find how they actually show up in the package,
# as they definitely are not in the tarball and should
# be generated on the target device using the postinst script
# OR: see python packaging guidelines if shipping with
# pre-compiled pyc & pyo is OK
%%define _unpackaged_files_terminate_build 0
Name: %(name)s
Version: %(version)s
Release: %(buildversion)s
Summary: %(summary)s
Group: %(section)s
License: %(license)s
URL: %(url)s
Source0: %(sources)s

BuildRoot: %%{_tmppath}/%%{name}-%%{version}-%%{release}-root-%%(%%{__id_u} -n)
BuildArch: noarch
BuildRequires: %(builddepends)s
Requires: %(depends)s

%%description
%(description)s

%%prep
%%setup

%%build

%%install
%(specrules)s
""" % self.options
        if self.options['postinst']:
            content = content + """
%%post
%(postinst)s
""" % self.options
        if self.options['postrm']:
            content = content + """%%postun
%(postrm)s
""" % self.options
        if self.options['prerm']:
            content = content + """%%preun
%(prerm)s
""" % self.options
        if self.options['preinst']:
            content = content + """%%pre
%(preinst)s
"""

        content = content + """%%clean
rm -rf %%{buildroot}


%%files
%%defattr(-,root,root,-)
%(packedfiles)s

%%changelog
%(changeslog)s

""" % self.options
        return content

    content = property(_getContent, doc="")
