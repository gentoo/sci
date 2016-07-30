# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit toolchain-funcs python-single-r1

DESCRIPTION="Map highly divergent short reads to a reference"
HOMEPAGE="http://www.well.ox.ac.uk/project-stampy"
SRC_URI="${P}.tar.gz"

LICENSE="stampy-academic"
SLOT="0"
KEYWORDS=""
IUSE=""

RESTRICT="fetch"

DEPEND=""
RDEPEND="${DEPEND}"

# FIXME: the makefile calls python but fails if that is under python-3.4, 2.7 works
src_install(){
	dobin *.py
	insinto $(python_get_sitedir)
	doins maptools.so
	# doins -r stampy-1.0.28/build/python2.7/Stampy # only *.pyc files available
	# doins -r python2.7/ext # only *.pyc files available
	fperms a+x "$(python_get_sitedir)"/maptools.so
	dodoc README.txt
}
