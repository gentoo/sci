#!/usr/bin/python
#
# createmodule.py - Takes the name of a environment init script and 
# produces a modulefile that duplicates the changes made by the init script
#
# Copyright (C) 2012 by Orion E. Poplawski <orion@cora.nwra.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

from optparse import OptionParser
import os,sys
from subprocess import *

# Handle options
usage = "Usage: %prog [-p prefix] <initscript> [args]"
parser = OptionParser()
parser.set_usage(usage)
parser.add_option('-p', '--prefix', dest='prefix', help='Specify path prefix')
(options, args) = parser.parse_args()

# Need a script name
if not args:
    parser.print_usage()
    exit(1)

# Return environment after a command
def getenv(cmd = ':'):
    env = {}
    p = Popen(cmd + ";env", shell=True, stdout=PIPE, stderr=PIPE)
    (stdout, stderr) = p.communicate()
    if p.returncode != 0:
        print "EROR: Could not execute initscript:"
        print "%s returned exit code %d" % (cmd, p.returncode)
        print stderr
        exit(1)
    if stderr != '':
        print "WARNING: initscript sent the following to stderr:"
        print stderr
    # Parse the output key=value pairs
    for line in stdout.splitlines():
        try:
            (var,value) = line.split('=',1)
        except ValueError:
            print "ERROR: Could not parse output:"
            print stdout
            exit(1)
        env[var] = value
    return env

#Record initial environment
env1=getenv()

#Record environment after sourcing the initscript
env2=getenv(". " + " ".join(args))

# Initialize our variables for storing modifications
chdir = None
appendpath = {}
prependpath = {}
setenv = {}
unsetenv = []
pathnames = []

# Function to nomalize all paths in a list of paths and remove duplicate items
def normpaths(paths):
    newpaths = []
    for path in paths:
        normpath = os.path.normpath(path)
        if normpath not in newpaths:
             newpaths.append(os.path.normpath(path))
    return newpaths

# Start with existing keys and look for changes
for key in env1.keys():
    # Test for delete
    if key not in env2:
        unsetenv.append(key)
        continue
    # No change
    if env1[key] == env2[key]:
        del env2[key]
        continue
    #Working directory change
    if key == 'PWD':
	chdir=os.path.normpath(env2[key])
        pathnames.append(chdir)
        del env2[key]
        continue
    # Determine modifcations to beginning and end of the string
    (prepend,append) = env2[key].split(env1[key])
    if prepend:
        prependpaths = prepend.strip(':').split(':')
        # LICENSE variables often include paths outside install directory
        if 'LICENSE' not in key:
            pathnames += prependpaths
        prependpath[key] = ':'.join(normpaths(prependpaths))
    if append:
        appendpaths = append.strip(':').split(':')
        # LICENSE variables often include paths outside install directory
        if 'LICENSE' not in key:
            pathnames += appendpaths
        appendpath[key] = ':'.join(normpaths(appendpaths))
    del env2[key]
      
# We're left with new keys in env2
for key in env2.keys():
    # Use prepend-path for new paths
    if ('PATH' in key) or (':' in env2[key]):
        prependpaths = env2[key].strip(':').split(':')
        # MANPATH can have system defaults added it it wasn't previously set
        # LICENSE variables often include paths outside install directory
        if key != 'MANPATH' and 'LICENSE' not in key:
            pathnames += prependpaths
        prependpath[key] = ':'.join(normpaths(prependpaths))
        continue
    # Set new variables
    setenv[key] = os.path.normpath(env2[key])
    if 'LICENSE' not in key:
        pathnames.append(setenv[key])

# Determine a prefix
prefix = None
if options.prefix:
    prefix = options.prefix
else:
    prefix = os.path.commonprefix(pathnames).rstrip('/')
    if prefix == '':
          prefix = None

# Print out the modulefile
print "#%Module 1.0"

# Prefix
if prefix is not None:
    print "\nset prefix " + prefix + "\n"

# Chdir
if chdir is not None:
    print "chdir\t" + chdir

# Function to format output line with tabs and substituting prefix
def formatline(item, key, value=None):
    print item,
    print "\t"*(2-(len(item)+1)/8),
    print key,
    if value is not None:
        print "\t"*(3-(len(key)+1)/8),
        if prefix is not None:
            print value.replace(prefix,'$prefix')
        else:
            print value

# Paths first, grouped by variable name
pathkeys = appendpath.keys() + prependpath.keys()
pathkeys.sort()
for key in pathkeys:
    if key in prependpath:
        formatline("prepend-path",key,prependpath[key])
    if key in appendpath:
        formatline("append-path",key,appendpath[key])

# Setenv
setenvkeys = setenv.keys()
setenvkeys.sort()
if setenvkeys:
    print
for key in setenvkeys:
    formatline("setenv",key,setenv[key])

# Unsetenv
unsetenv.sort()
if unsetenv:
    print
for key in unsetenv:
    formatline("unsetenv",key)
