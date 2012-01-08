# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils prefix

MY_PN="opengltk"
MY_P="${MY_PN}-${PV/_rc2/}"

PYTHON_MODNAME="${MY_PN}"

DESCRIPTION="MGLTools Plugin -- opengltk"
HOMEPAGE="http://mgltools.scripps.edu"
#SRC_URI="http://mgltools.scripps.edu/downloads/tars/releases/REL${PV}/mgltools_source_${PV}.tar.gz"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/mgltools_source_${PV/_/}.tar.gz"

LICENSE="MGLTOOLS"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-lang/tk
	dev-python/numpy
	dev-tcltk/tkdnd
	dev-tcltk/togl
	virtual/opengl"
DEPEND="${RDEPEND}
	dev-lang/swig"

S="${WORKDIR}"/${MY_P}

src_unpack() {
	tar xzpf "${DISTDIR}"/${A} mgltools_source_${PV/_/}/MGLPACKS/${MY_P}.tar.gz
	tar xzpf mgltools_source_${PV/_/}/MGLPACKS/${MY_P}.tar.gz
}

src_prepare() {
	local tcl_ver="$(best_version dev-lang/tcl | cut -d- -f3 | cut -d. -f1,2)"

	epatch "${FILESDIR}"/${P}-unbundle.patch

	eprefixify setup.py

	ecvs_clean
	find "${S}" -name LICENSE -type f -delete || die
	find Togl2.0 tkdnd2.0 include/tcltk84 -delete || die

	sed  \
		-e 's:^.*CVS:#&1:g' \
		-e 's:^.*LICENSE:#&1:g' \
		-i "${S}"/MANIFEST.in || die

	sed \
		-e "s:8.4:${tcl_ver}:g" \
		-e "s:8.5:${tcl_ver}:g" \
		-i setup.py || die
	distutils_src_prepare
}
