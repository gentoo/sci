# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit toolchain-funcs python-r1 python-utils-r1

DESCRIPTION="Map highly divergent short reads to a reference"
HOMEPAGE="http://www.well.ox.ac.uk/project-stampy"
SRC_URI="stampy-${PV}.tar.gz"

LICENSE="stampy-academic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="fetch"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/stampy-${PV}

# FIXME: the makefile calls python but fails if that is under python-3.4, 2.7 works
# FIXME: respect CC and CXX

src_prepare(){
	sed -e 's/-O2 -Wall/$(CFLAGS)/' -i makefile || die
}

src_install(){
	dobin *.py
	python_foreach_impl python_domodule maptools.so
	python_moduleinto Stampy
	python_foreach_impl python_domodule build/python2.7/Stampy/*.pyc # only *.pyc files available
	python_moduleinto ext
	python_foreach_impl python_domodule build/python2.7/ext/*.pyc # only *.pyc files available
	python_moduleinto plugins
	python_foreach_impl python_domodule build/python2.7/plugins/*.py*
	dodoc README.txt
}
