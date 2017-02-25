# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils eutils git-r3 perl-module

DESCRIPTION="Perl bindings for OpenBabel"
HOMEPAGE="http://openbabel.sourceforge.net/"
EGIT_REPO_URI="https://github.com/openbabel/openbabel.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-lang/perl
	~sci-chemistry/openbabel-${PV}"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.8
	>=dev-lang/swig-2"

src_unpack() {
	git-r3_src_unpack
}

src_configure() {
	perl_set_version
	local mycmakeargs=(
		-DOPTIMIZE_NATIVE=OFF
		-DCMAKE_INSTALL_RPATH=
		-DBINDINGS_ONLY=ON
		-DBABEL_SYSTEM_LIBRARY="${EPREFIX}"/usr/$(get_libdir)/libopenbabel.so
		-DOB_MODULE_PATH="${EPREFIX}"/usr/$(get_libdir)/openbabel/${PV}
		-DLIB_INSTALL_DIR="${ED}/${VENDOR_ARCH}"
		-DPERL_BINDINGS=ON
		-DRUN_SWIG=ON
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile bindings_perl
}

src_test() {
	mkdir "${BUILD_DIR}/$(get_libdir)/Chemistry"
	cp \
		"${CMAKE_USE_DIR}/scripts/perl/OpenBabel.pm" \
		"${BUILD_DIR}/$(get_libdir)/Chemistry/"
	for i in "${CMAKE_USE_DIR}"/scripts/perl/t/*; do
		einfo "Running test: ${i}"
		perl -I"${BUILD_DIR}/$(get_libdir)" "${i}" || die
	done
}

src_install() {
	cd "${BUILD_DIR}" || die
	cmake -DCOMPONENT=bindings_perl -P cmake_install.cmake
}
