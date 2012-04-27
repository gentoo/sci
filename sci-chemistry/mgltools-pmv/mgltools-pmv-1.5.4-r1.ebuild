# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_PN="Pmv"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="mgltools plugin -- Pmv"
HOMEPAGE="http://mgltools.scripps.edu"
#SRC_URI="http://mgltools.scripps.edu/downloads/tars/releases/REL${PV}/mgltools_source_${PV}.tar.gz"
SRC_URI="http://dev.gentooexperimental.org/~jlec/distfiles/mgltools_source_${PV}.tar.gz"

LICENSE="MGLTOOLS"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-lang/swig"

RESTRICT_PYTHON_ABIS="3.* 2.7-pypy-*"
S="${WORKDIR}"/${MY_P}

DOCS="Pmv/RELNOTES Pmv/doc/*.pdf"

src_unpack() {
	tar xzpf "${DISTDIR}"/${A} mgltools_source_${PV}/MGLPACKS/${MY_P}.tar.gz
	tar xzpf mgltools_source_${PV}/MGLPACKS/${MY_P}.tar.gz
}

src_prepare() {
	find "${S}" -name CVS -type d -exec rm -rf '{}' \; >& /dev/null
	find "${S}" -name LICENSE -type f -exec rm -f '{}' \; >& /dev/null

	sed  \
		-e 's:^.*CVS:#&1:g' \
		-e 's:^.*LICENSE:#&1:g' \
		-i "${S}"/MANIFEST.in
	distutils_src_prepare
}

src_install() {
	distutils_src_install

	sed '1s:^.*$:#!/usr/bin/python:g' -i Pmv/bin/runPmv || die
	dobin Pmv/bin/runPmv || die
}

pkg_postinst() {
	python_mod_optimize ${MY_PN}
}

pkg_postrm() {
	python_mod_cleanup ${MY_PN}
}
