# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

if [ ${PV} == "9999" ] ; then
	inherit git-3
	EGIT_REPO_URI="https://github.com/STEllAR-GROUP/hpx.git"
	SRC_URI=""
	KEYWORDS=""
	S="${WORKDIR}/${PN}"
	CMAKE_USE_DIR="${S}"
else
	SRC_URI="http://stellar.cct.lsu.edu/files/${PN}_${PV}.7z"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
	S="${WORKDIR}/${PN}_${PV}"
fi

inherit cmake-utils fortran-2 python-single-r1

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
	jemalloc? ( dev-libs/jemalloc )
	papi? ( dev-libs/papi )
	perftools? ( >=dev-util/google-perftools-1.7.1 )
	tbb? ( dev-cpp/tbb )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-lang/python )
"
REQUIRED_USE="test? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	"${FILESDIR}"/hpx-0.9.5-install-path.patch
	"${FILESDIR}"/hpx-0.9.7-move-boost-include.patch
)

pkg_setup() {
	use test && python-single-r1_pkg_setup
}

src_configure() {
	CMAKE_BUILD_TYPE=Release
	local mycmakeargs=(
		-Wno-dev
		-DHPX_BUILD_EXAMPLES=OFF
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
