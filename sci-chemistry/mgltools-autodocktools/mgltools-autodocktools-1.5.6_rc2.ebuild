# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* 2.7-pypy-*"
PYTHON_USE_WITH="tk"

inherit distutils eutils

MY_PN="AutoDockTools"
MY_P="${MY_PN}-${PV/_rc2/}"

PYTHON_MODNAME="${MY_PN}"

DESCRIPTION="MGLTools Plugin -- "
HOMEPAGE="http://mgltools.scripps.edu"
#SRC_URI="http://mgltools.scripps.edu/downloads/tars/releases/REL${PV}/mgltools_source_${PV}.tar.gz"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/mgltools_source_${PV/_/}.tar.gz"

LICENSE="MGLTOOLS"
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

S="${WORKDIR}"/${MY_P}

DOCS="AutoDockTools/RELNOTES"

src_unpack() {
	tar xzpf "${DISTDIR}"/${A} mgltools_source_${PV/_/}/MGLPACKS/${MY_P}.tar.gz
	tar xzpf mgltools_source_${PV/_/}/MGLPACKS/${MY_P}.tar.gz
}

src_prepare() {
	ecvs_clean
	find "${S}" -name LICENSE -type f -delete || die

	sed  \
		-e 's:^.*CVS:#&1:g' \
		-e 's:^.*LICENSE:#&1:g' \
		-i "${S}"/MANIFEST.in || die
	distutils_src_prepare
}

src_install() {
	distutils_src_install

	sed '1s:^.*$:#!/usr/bin/python:g' -i AutoDockTools/bin/runAdt || die
	dobin AutoDockTools/bin/runAdt || die
}
