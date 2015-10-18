# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils multilib python-any-r1

DESCRIPTION="Intel Concurrent Collections for C++ - Parallelism without the Pain"
HOMEPAGE="https://software.intel.com/en-us/articles/intel-concurrent-collections-for-cc"

if [[ $PV = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/icnc/icnc.git"
	KEYWORDS=
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"
IUSE="doc examples mpi test"

RDEPEND="
	>=dev-cpp/tbb-4.2
	sys-libs/glibc
	mpi? ( virtual/mpi )
	"
DEPEND="
	${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( ${PYTHON_DEPS} )
	"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use mpi BUILD_LIBS_FOR_MPI)
		-DLIB=$(get_libdir)
		$(cmake-utils_use_find_package doc Doxygen)
		$(cmake-utils_use test ENABLE_TESTING)
		-DRUN_DIST=OFF
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	if use doc; then
		mv "${ED}"/usr/share/{icnc/doc/api,doc/${P}/html} || die
		rmdir "${ED}"/usr/share/icnc/doc || die
	fi
	use examples || rm -r "${ED}"/usr/share/icnc/samples || die
}
