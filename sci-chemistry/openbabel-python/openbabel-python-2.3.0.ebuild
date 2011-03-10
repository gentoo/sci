# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/openbabel/openbabel-2.2.3.ebuild,v 1.11 2010/07/18 14:53:22 armin76 Exp $

EAPI="3"

PYTHON_DEPEND="*:2.4"
SUPPORT_PYTHON_ABIS="1"
PYTHON_MODNAME="openbabel.py pybel.py"

inherit cmake-utils eutils python distutils

DESCRIPTION="Python bindings for OpenBabel (including Pybel)"
HOMEPAGE="http://openbabel.sourceforge.net/"
SRC_URI="mirror://sourceforge/openbabel/openbabel-${PV}.tar.gz"

KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

RDEPEND="
	~sci-chemistry/openbabel-${PV}
	dev-libs/libxml2:2
	!sci-chemistry/babel
	dev-cpp/eigen:2
	sys-libs/zlib"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6.0"

S="${WORKDIR}/openbabel-${PV}"

DISTUTILS_SETUP_FILES="${WORKDIR}/openbabel-${PV}/scripts/python/setup.py"

src_configure() {
	local mycmakeargs="-DPYTHON_BINDINGS=ON"
	cmake-utils_src_configure
}

src_compile() {
	#cmake-utils_src_compile _openbabel
	cd "${WORKDIR}/${P}_build/scripts"
	distutils_src_compile
}

src_install() {
	cd "${WORKDIR}/${P}_build/scripts"
	distutils_src_install
}
