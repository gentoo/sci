# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Stretching GPU performance for GEMMs and tensor contractions"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/Tensile"
SRC_URI="https://github.com/ROCmSoftwarePlatform/Tensile/archive/rocm-${PV}.tar.gz -> rocm-Tensile-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-rocm-${PVR}"

src_install() {
	distutils-r1_src_install

	dodir "/usr/$(get_libdir)/cmake"
	mv "${ED}/usr/cmake" "${ED}/usr/$(get_libdir)/cmake/${PN}" || die
}
