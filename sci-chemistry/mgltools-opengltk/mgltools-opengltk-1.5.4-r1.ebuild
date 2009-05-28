# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils multilib

MY_P="${P/mgltools-}"
MGL_EXTRALIBS="/usr/$(get_libdir)"
MGL_EXTRAINCLUDE="/usr/include"

DESCRIPTION="mgltools plugin -- opengltk"
HOMEPAGE="http://mgltools.scripps.edu"
#SRC_URI="http://mgltools.scripps.edu/downloads/tars/releases/REL${PV}/mgltools_source_${PV}.tar.gz"
SRC_URI="http://dev.gentooexperimental.org/~jlec/distfiles/mgltools_source_${PV}.tar.gz"

LICENSE="MGLTOOLS"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/tk
	virtual/glu
	virtual/opengl
	dev-python/numpy"
DEPEND="${RDEPEND}
	dev-lang/swig"

S="${WORKDIR}"/${MY_P}

src_unpack() {
	tcl_ver="$(best_version dev-lang/tcl | cut -d- -f3 | cut -d. -f1,2)"

	tar xzpf "${DISTDIR}"/${A} mgltools_source_${PV}/MGLPACKS/${MY_P}.tar.gz
	tar xzpf mgltools_source_${PV}/MGLPACKS/${MY_P}.tar.gz

	find "${S}" -name CVS -type d -exec rm -rf '{}' \; >& /dev/null
	find "${S}" -name LICENSE -type f -exec rm -f '{}' \; >& /dev/null

	sed  \
		-e 's:^.*CVS:#&1:g' \
		-e 's:^.*LICENSE:#&1:g' \
		-i "${S}"/MANIFEST.in

	sed "s:8.4:${tcl_ver}:g" -i ${MY_P}/setup.py
}
