# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
CMAKE_BUILD_TYPE=Debug
CMAKE_VERBOSE=1
if [ "${PV%9999}" != "${PV}" ] ; then
	SCM=git-2
	EGIT_REPO_URI="git://github.com/pathscale/${PN}-suite.git"
	EGIT_HAS_SUBMODULES=yes
	PATH64_URI="compiler assembler"
	PATHSCALE_URI="compiler-rt libcxxrt libdwarf-bsd libunwind stdcxx"
	DBG_URI="git://github.com/path64/debugger.git"

fi

inherit cmake-utils ${SCM} multilib toolchain-funcs

DESCRIPTION="PathScale EKOPath Compiler Suite"
HOMEPAGE="http://www.pathscale.com/ekopath-compiler-suite"
if [ "${PV%9999}" != "${PV}" ] ; then
	SRC_URI=""
else
	SRC_URI=""  # for tarballs
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="custom-cflags"
#TODO: openmp, fortran flags

DEPEND="sys-devel/gcc:4.2[vanilla]"
RDEPEND="${DEPEND}"

pkg_setup() {
	[[ $(gcc-version) != 4.2 ]] && \
		die "To bootstrap Path64 you'll need to use gcc:4.2[vanilla]"
	export GCC42_PATH=$($(tc-getCC) -print-search-dirs | head -n 1 | cut -f2- -d' ')
}

src_unpack() {
	git-2_src_unpack
	cd "${S}"
	mkdir compiler
	for f in ${PATH64_URI}; do
		EGIT_REPO_URI="git://github.com/${PN}/${f}.git" \
		EGIT_DIR="${EGIT_STORE_DIR}/compiler/${f}" \
		EGIT_SOURCEDIR="${WORKDIR}/${P}/compiler/${f}" git-2_src_unpack
	done
	for f in ${PATHSCALE_URI}; do
		EGIT_REPO_URI="git://github.com/pathscale/${f}.git" \
		EGIT_DIR="${EGIT_STORE_DIR}/compiler/${f}" \
		EGIT_SOURCEDIR="${WORKDIR}/${P}/compiler/${f}" git-2_src_unpack
	done
	EGIT_REPO_URI=${DBG_URI} EGIT_DIR="${EGIT_STORE_DIR}/compiler/pathdb" \
		EGIT_SOURCEDIR="${WORKDIR}/${P}/compiler/pathdb" git-2_src_unpack
}

src_configure() {
	local MY_CFLAGS=""
	local MY_CXXFLAGS=""
	if use custom-cflags; then
		MY_CFLAGS=${CFLAGS}
		MY_CXXFLAGS=${CXXFLAGS}
	fi
	local linker=$($(tc-getCC) --help -v 2>&1 >/dev/null | grep	'\-dynamic\-linker' | cut -f7 -d' ')
	local libgcc=$($(tc-getCC) -print-libgcc-file-name)
	local crt=$($(tc-getCC) -print-file-name=crt1.o)
	mycmakeargs=(
		-DPATH64_ENABLE_TARGETS="x86_64"
		-DPATH64_ENABLE_PROFILING=ON
		-DPATH64_ENABLE_FORTRAN=ON
		-DPATH64_ENABLE_MATHLIBS=ON
		-DPATH64_ENABLE_OPENMP=ON
		-DPATH64_ENABLE_PATHOPT2=OFF
		-DPSC_CRT_PATH_x86_64=$(dirname ${crt})
		-DPSC_CRTBEGIN_PATH=$(dirname ${libgcc})
		-DPSC_DYNAMIC_LINKER_x86_64=${linker}
		-DCMAKE_Fortran_COMPILER=$(tc-getFC)
		-DCMAKE_C_COMPILER=$(tc-getCC)
		-DCMAKE_C_FLAGS=${MY_CFLAGS}
		-DCMAKE_CXX_COMPILER=$(tc-getCXX)
		-DCMAKE_CXX_FLAGS=${MY_CXXFLAGS}
	)
	cmake-utils_src_configure
}
