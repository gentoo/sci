# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
PYTHON_USE_WITH="tk"

inherit distutils

MY_P="AutoDockTools-${PV}"

DESCRIPTION="mgltools plugin -- autodocktools"
HOMEPAGE="http://mgltools.scripps.edu"
#SRC_URI="http://mgltools.scripps.edu/downloads/tars/releases/REL${PV}/mgltools_source_${PV}.tar.gz"
SRC_URI="http://dev.gentooexperimental.org/~jlec/distfiles/mgltools_source_${PV}.tar.gz"

LICENSE="MGLTOOLS MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/imaging[tk]
	dev-python/zsi
	sci-chemistry/autodock
	sci-chemistry/mgltools-dejavu
	sci-chemistry/mgltools-geomutils
	sci-chemistry/mgltools-mglutil
	sci-chemistry/mgltools-molkit
	sci-chemistry/mgltools-opengltk
	sci-chemistry/mgltools-pmv
	sci-chemistry/mgltools-pybabel
	sci-chemistry/mgltools-pyglf
	sci-chemistry/mgltools-support
	sci-chemistry/mgltools-viewer-framework"
DEPEND="${RDEPEND}
	dev-lang/swig"

RESTRICT_PYTHON_ABIS="3.* 2.7-pypy-*"

S="${WORKDIR}"/${MY_P}

DOCS="AutoDockTools/RELNOTES"

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

	sed '1s:^.*$:#!/usr/bin/python:g' -i AutoDockTools/bin/runAdt || die
	dobin AutoDockTools/bin/runAdt || die
}

pkg_postinst() {
	python_mod_optimize AutoDockTools
}

pkg_postrm() {
	python_mod_cleanup AutoDockTools
}
