# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE=Release
CMAKE_MAKEFILE_GENERATOR=emake
inherit cmake

DESCRIPTION="AMD library for optimized sparse BLAS operations"
HOMEPAGE="https://developer.amd.com/amd-aocl/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/amd/aocl-sparse"
else
	SRC_URI="https://github.com/amd/aocl-sparse/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"

BDEPEND="dev-vcs/git"

src_prepare() {
	sed -e 's/-march=native//' \
	    -e '/^[[:space:]]*set[[:space:]]*([[:space:]]*CMAKE_INSTALL_LIBDIR[[:space:]].*)/I{s/^/#_cmake_modify_IGNORE /g}' \
	    -i CMakeLists.txt || die
	sed -e 's:${CMAKE_INSTALL_PREFIX}/lib:${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}:' \
	    -i library/CMakeLists.txt || die
	sed -e 's:$AOCLSPARSE_ROOT/lib/:$AOCLSPARSE_ROOT/library:' \
	    -e 's:-O3::' \
	    -i tests/test.sh || die
	cmake_src_prepare
}

src_compile() {
	cmake_src_compile

	cd tests
	emake -f - <<EOF
test_aocl_sparse:
	\$(CXX) -DNDEBUG -o test_aocl_sparse sample_csrmv.cpp -I../library/include -I${BUILD_DIR}/include -L${BUILD_DIR}/library -laoclsparse
EOF
}

src_test() {
	cd tests
	LD_LIBRARY_PATH=${BUILD_DIR}/library ./test_aocl_sparse || die
}
