# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils git-r3 multilib python-any-r1

DESCRIPTION="Intel Concurrent Collections for C++ - Parallelism without the Pain"
HOMEPAGE="https://software.intel.com/en-us/articles/intel-concurrent-collections-for-cc"
EGIT_REPO_URI="https://github.com/icnc/icnc.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=
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
		mv "${ED}"/usr/share/{icnc/doc/api,doc/${PF}/html} || die
		rmdir "${ED}"/usr/share/icnc/doc || die
	fi
	if ! use examples; then
		rm -r "${ED}"/usr/share/icnc/samples || die
	fi
}
