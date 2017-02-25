# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="tk"

inherit distutils-r1 eutils

MY_PN="AutoDockTools"
MY_P="${MY_PN}-${PV/_rc3/}"

DESCRIPTION="MGLTools Plugin -- AutoDockTools"
HOMEPAGE="http://mgltools.scripps.edu"
SRC_URI="http://mgltools.scripps.edu/downloads/tars/releases/REL${PV}/mgltools_source_${PV}.tar.gz"

LICENSE="MGLTOOLS MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/zsi[${PYTHON_USEDEP}]
	sci-chemistry/autodock
	sci-chemistry/mgltools-dejavu[${PYTHON_USEDEP}]
	sci-chemistry/mgltools-geomutils[${PYTHON_USEDEP}]
	sci-chemistry/mgltools-mglutil[${PYTHON_USEDEP}]
	sci-chemistry/mgltools-molkit[${PYTHON_USEDEP}]
	sci-chemistry/mgltools-opengltk[${PYTHON_USEDEP}]
	sci-chemistry/mgltools-pmv[${PYTHON_USEDEP}]
	sci-chemistry/mgltools-pybabel[${PYTHON_USEDEP}]
	sci-chemistry/mgltools-pyglf[${PYTHON_USEDEP}]
	sci-chemistry/mgltools-support[${PYTHON_USEDEP}]
	sci-chemistry/mgltools-viewer-framework[${PYTHON_USEDEP}]
	dev-python/pillow[tk,${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-lang/swig"

S="${WORKDIR}"/${MY_P}

DOCS=( AutoDockTools/RELNOTES )

src_unpack() {
	tar xzpf "${DISTDIR}"/${A} mgltools_source_${PV/_/}/MGLPACKS/${MY_P}.tar.gz || die
	tar xzpf mgltools_source_${PV/_/}/MGLPACKS/${MY_P}.tar.gz || die
}

python_prepare_all() {
	ecvs_clean
	find "${S}" -name LICENSE -type f -delete || die

	sed  \
		-e 's:^.*CVS:#&1:g' \
		-e 's:^.*LICENSE:#&1:g' \
		-i "${S}"/MANIFEST.in || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	sed '1s:^.*$:#!/usr/bin/python:g' -i AutoDockTools/bin/runAdt || die
	python_foreach_impl python_doscript AutoDockTools/bin/runAdt
}
