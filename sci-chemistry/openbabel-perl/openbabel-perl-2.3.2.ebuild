# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils eutils #perl-module

DESCRIPTION="Perl bindings for OpenBabel"
HOMEPAGE="http://openbabel.sourceforge.net/"
SRC_URI="mirror://sourceforge/openbabel/openbabel-${PV}.tar.gz"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

RDEPEND="
	dev-lang/perl
	~sci-chemistry/openbabel-${PV}"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.8
	>=dev-lang/swig-2"

S="${WORKDIR}/openbabel-${PV}"

src_prepare() {
	epatch "${FILESDIR}/${P}-trunk_cmake.patch"
	epatch "${FILESDIR}/${P}-bindings_only.patch"
}

src_configure() {
	#perl-module_src_configure
	eval "$(${EPREFIX}/usr/bin/perl -V:installvendorarch)"
	local mycmakeargs="${mycmakeargs}
		-DCMAKE_INSTALL_RPATH=
		-DBINDINGS_ONLY=ON
		-DBABEL_SYSTEM_LIBRARY=${EPREFIX}/usr/$(get_libdir)/libopenbabel.so
		-DOB_MODULE_PATH=${EPREFIX}/usr/$(get_libdir)/openbabel/${PV}
		-DLIB_INSTALL_DIR=${ED}/${installvendorarch}
		-DPERL_BINDINGS=ON
		-DRUN_SWIG=ON"

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile bindings_perl
}

src_test() {
	mkdir "${CMAKE_BUILD_DIR}/$(get_libdir)/Chemistry"
	cp \
		"${CMAKE_USE_DIR}/scripts/perl/OpenBabel.pm" \
		"${CMAKE_BUILD_DIR}/$(get_libdir)/Chemistry/"
	for i in "${CMAKE_USE_DIR}"/scripts/perl/t/*
	do
		echo ${i}
		"${EPREFIX}"/usr/bin/perl -I"${CMAKE_BUILD_DIR}/$(get_libdir)" "${i}" || die
	done
}

src_install() {
	cd "${CMAKE_BUILD_DIR}"
	cmake -DCOMPONENT=bindings_perl -P cmake_install.cmake
}
