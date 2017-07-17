# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1

DESCRIPTION="Emscripten LLVM backend - Fastcomp is the default compiler core for Emscripten"
HOMEPAGE="http://emscripten.org/"
SRC_URI="https://github.com/kripken/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/kripken/${PN}-clang/archive/${PV}.tar.gz -> ${PN}-clang-${PV}.tar.gz"
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="UoI-NCSA"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

MY_DEPEND="${PYTHON_DEPS}
	>=net-libs/nodejs-0.12.10"
DEPEND="${MY_DEPEND}
	>=dev-util/cmake-3.4.3"
RDEPEND="${MY_DEPEND}
	>=virtual/jre-1.5"

src_prepare() {
	eapply "${FILESDIR}/${PV}/CMakeLists.txt.patch"
	cd "${S}/../${PN}-clang-${PV}" || \
		die "Could not change to directory '${S}/../${PN}-clang-${PV}'"
	eapply "${FILESDIR}/${PV}/Version.cpp.patch"
	cd "${S}" || die "Could not change to directory '${S}'"
	eapply_user
}

src_configure() {
	# create symlink to tools/clang
	ln -s "${WORKDIR}/${PN}-clang-${PV}/" "${WORKDIR}/${P}/tools/clang" \
		|| die "Could not create symlink to tools/clang"
	local mycmakeargs=(
		# avoid clashes with sys-devel/llvm
		-DCMAKE_INSTALL_PREFIX="/usr/share/${P}"
		-DLLVM_OCAML_INSTALL_PATH="/usr/share/${P}/ocaml"
		-DLLVM_ENABLE_OCAMLDOC=OFF
		-DLLVM_TARGETS_TO_BUILD="X86;JSBackend"
		-DLLVM_INCLUDE_EXAMPLES=OFF
		-DLLVM_INCLUDE_TESTS=OFF
		-DCLANG_INCLUDE_EXAMPLES=OFF
		-DCLANG_INCLUDE_TESTS=OFF
		-DCLANG_INCLUDE_DOCS=OFF
		-DLLVM_INCLUDE_DOCS=OFF
	)
	cmake-utils_src_configure
}
