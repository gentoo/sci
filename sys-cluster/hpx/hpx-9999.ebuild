# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/STEllAR-GROUP/hpx.git"
	KEYWORDS=""
else
	SRC_URI="http://stellar.cct.lsu.edu/files/${PN}_${PV}.7z"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
	S="${WORKDIR}/${PN}_${PV}"
fi

inherit cmake-utils fortran-2 multilib python-single-r1

DESCRIPTION="C++ runtime system for parallel and distributed applications"
HOMEPAGE="http://stellar.cct.lsu.edu/tag/hpx/"

SLOT="0"
LICENSE="Boost-1.0"
IUSE="doc examples jemalloc papi +perftools tbb test"

# TODO: some of the forced deps are may be optional
# it would need to work the automagic
RDEPEND="
	>=dev-libs/boost-1.51
	dev-libs/libxml2
	sci-libs/hdf5
	>=sys-apps/hwloc-1.8
	>=sys-libs/libunwind-1
	sys-libs/zlib
	papi? ( dev-libs/papi )
	perftools? ( >=dev-util/google-perftools-1.7.1 )
	tbb? ( dev-cpp/tbb )
"
DEPEND="${RDEPEND}
	app-arch/p7zip
	virtual/pkgconfig
	test? ( ${PYTHON_DEPS} )
	doc? ( >=dev-libs/boost-1.56.0-r1[tools] )
"
REQUIRED_USE="test? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	use test && python-single-r1_pkg_setup
}

src_configure() {
	CMAKE_BUILD_TYPE=Release
	local mycmakeargs=(
		-DHPX_BUILD_EXAMPLES=OFF
		-DLIB=$(get_libdir)
		-Dcmake_dir=cmake
		$(cmake-utils_use doc HPX_BUILD_DOCUMENTATION)
		$(cmake-utils_use jemalloc HPX_JEMALLOC)
		$(cmake-utils_use test BUILD_TESTING)
		$(cmake-utils_use perftools HPX_GOOGLE_PERFTOOLS)
		$(cmake-utils_use papi HPX_PAPI)
	)
	if use perftools; then
		mycmakeargs+=( -DHPX_MALLOC=tcmalloc )
	elif use jemalloc; then
		mycmakeargs+=( -DHPX_MALLOC=jemalloc )
	elif use tbb; then
		mycmakeargs+=( -DHPX_MALLOC=tbbmalloc )
	else
		mycmakeargs+=( -DHPX_MALLOC=system )
	fi
	cmake-utils_src_configure
}

src_test() {
	# avoid over-suscribing
	cmake-utils_src_make -j1 tests
}

src_install() {
	cmake-utils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
