# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="mslib"
MY_P="${MY_PN}-${PV/_rc2/}"

DESCRIPTION="MSMS library python extension module"
HOMEPAGE="http://mgltools.scripps.edu/downloads#msms"
SRC_URI="http://mgltools.scripps.edu/downloads/tars/releases/REL${PV}/mgltools_source_${PV}.tar.gz"

LICENSE="MGLTOOLS"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-lang/swig"

S="${WORKDIR}"/${MY_P}

PATCHES=( "${FILESDIR}"/build-with-linux-3.0.patch )

src_unpack() {
	tar xzpf "${DISTDIR}"/${A} mgltools_source_${PV/_/}/MGLPACKS/${MY_P}.tar.gz
	tar xzpf mgltools_source_${PV/_/}/MGLPACKS/${MY_P}.tar.gz
}

python_prepare_all() {
	distutils-r1_python_prepare_all
	pushd "${S}"/lib >/dev/null
	# Set up symlinks for 3.x kernels
	for x in *inux2; do
		ln -s ${x} ${x%2}3
	done
	popd >/dev/null
}
