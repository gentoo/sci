# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"

inherit cmake fortran-2

MY_PN=MCFM
MY_P=${MY_PN}-${PV}

DESCRIPTION="Monte Carlo for FeMtobarn processes"
HOMEPAGE="https://mcfm.fnal.gov"
SRC_URI="https://mcfm.fnal.gov/downloads/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

# Manual states multithreading bug in lhapdf-6.3.0 ?!
# MCFM has been tested against lhapdf-6.2.0 which ::gentoo already dropped
DEPEND="
	sci-physics/lhapdf
	>=sci-libs/qd-2.3.22
	>=sci-physics/qcdloop-2.0.5
	>=sci-physics/oneloop-3.6_p20200731
	>=sci-libs/handyg-0.1.5
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-rest.patch
)
src_prepare() {
	sed -i -e 's/\(name=".*\)"/\1_"/g' src/Mods/mod_qcdloop_c.f || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-Duse_external_lhapdf=ON
		-Duse_internal_lhapdf=OFF
		-Dlhapdf_include_path=ON
		-Dwith_library=ON
		-Dwith_vvamp=OFF
	)
	cmake_src_configure
	# Fix relative path in working dir to something absolute
	sed -i "s/process\.DAT/${EPREFIX}\/usr\/share\/${MY_PN}\/process\.DAT/g" src/Procdep/chooser.f || die
}

src_compile() {
	# Single thread force needed since fortan mods depend on each other
	# This problem only happend very rarely
	export MAKEOPTS=-j1
	cmake_src_compile
}

src_install() {
	# this did not work
	#cmake_src_install
	dobin "${BUILD_DIR}"/mcfm
	dolib.so "${BUILD_DIR}"/libmcfm.so
	insinto "/usr/share/${MY_PN}/"
	doins "Bin/process.DAT"
}
