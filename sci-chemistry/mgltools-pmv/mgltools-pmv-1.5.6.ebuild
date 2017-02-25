# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

MY_PN="Pmv"
MY_P="${MY_PN}-${PV/_rc3/}"

DESCRIPTION="MGLTools Plugin -- Pmv"
HOMEPAGE="http://mgltools.scripps.edu"
SRC_URI="http://mgltools.scripps.edu/downloads/tars/releases/REL${PV}/mgltools_source_${PV}.tar.gz"

LICENSE="MGLTOOLS MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	sci-chemistry/mgltools-dejavu[${PYTHON_USEDEP}]
	sci-chemistry/mgltools-mglutil[${PYTHON_USEDEP}]
	sci-chemistry/mgltools-molkit[${PYTHON_USEDEP}]
	sci-chemistry/mgltools-opengltk[${PYTHON_USEDEP}]
	sci-chemistry/mgltools-pybabel[${PYTHON_USEDEP}]
	sci-chemistry/mgltools-support[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	dev-lang/swig"

S="${WORKDIR}"/${MY_P}

DOCS=( Pmv/RELNOTES Pmv/doc )

src_unpack() {
	tar xzpf "${DISTDIR}"/${A} mgltools_source_${PV/_/}/MGLPACKS/${MY_P}.tar.gz || die
	tar xzpf mgltools_source_${PV/_/}/MGLPACKS/${MY_P}.tar.gz || die
}

python_prepare_all() {
	local PATCHES=( "${FILESDIR}"/${PN}-1.5.6_rc2-code-fix.patch )
	ecvs_clean
	find "${S}" -name LICENSE -type f -delete || die

	sed  \
		-e 's:^.*CVS:#&1:g' \
		-e 's:^.*LICENSE:#&1:g' \
		-i "${S}"/MANIFEST.in || die
	distutils-r1_python_prepare_all
}
