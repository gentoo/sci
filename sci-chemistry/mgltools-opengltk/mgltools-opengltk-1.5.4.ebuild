# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils multilib

MY_P="${P/mgltools-}"
MGL_EXTRALIBS="/usr/$(get_libdir)"
MGL_EXTRAINCLUDE="/usr/include"

DESCRIPTION="mgltools plugin -- pyglf"
HOMEPAGE="http://mgltools.scripps.edu"
SRC_URI="http://mgltools.scripps.edu/downloads/tars/releases/REL${PV}/mgltools_source_${PV}.tar.gz"

LICENSE="MGLTOOLS"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/tk
	virtual/glu
	virtual/opengl
	dev-python/numpy
	dev-tcltk/togl"
DEPEND="${RDEPEND}
	dev-lang/swig"

S="${WORKDIR}"/${MY_P}

src_unpack() {
	tar xzpf "${DISTDIR}"/${A} mgltools_source_${PV}/MGLPACKS/${MY_P}.tar.gz
	tar xzpf mgltools_source_${PV}/MGLPACKS/${MY_P}.tar.gz
	rm -rvf ${MY_P}/Togl

	sed 's:build_togl=1:build_togl=0:g' -i ${MY_P}/setup.py
}
