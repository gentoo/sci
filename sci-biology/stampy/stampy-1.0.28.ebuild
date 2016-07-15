# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

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

src_install(){
	dobin *.py
	local dest=/usr/$(get_libdir) # FIXME: still not correct
	insinto "${dest}"
	doins maptools.so
	fperms a+x ${dest}/maptools.so
	dodoc README.txt
}
