# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils eutils java-pkg-2 git-2

DESCRIPTION="Java bindings for OpenBabel"
HOMEPAGE="http://openbabel.sourceforge.net/"
EGIT_REPO_URI="https://github.com/openbabel/openbabel.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

COMMON_DEP="~sci-chemistry/openbabel-${PV}"

DEPEND="${COMMON_DEP}
	>=dev-lang/swig-1.3.29
	>=virtual/jdk-1.7"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.7"

CMAKE_IN_SOURCE_BUILD=1

src_configure() {
	local mycmakeargs="${mycmakeargs}
		-DCMAKE_INSTALL_RPATH=
		-DBINDINGS_ONLY=ON
		-DBABEL_SYSTEM_LIBRARY=${EPREFIX}/usr/$(get_libdir)/libopenbabel.so
		-DOB_MODULE_PATH=${EPREFIX}/usr/$(get_libdir)/openbabel/${PV}
		-DLIB_INSTALL_DIR=${S}/$(get_libdir)
		-DJAVA_BINDINGS=ON
		-DJAVA_INCLUDE_PATH=${EPREFIX}$(java-config-2 -o)/include
		-DJAVA_INCLUDE_PATH2=${EPREFIX}$(java-config-2 -o)/include/linux
		-DJAVA_AWT_INCLUDE_PATH=${EPREFIX}$(java-config-2 -o)/include
		-DJAVA_AWT_LIBRARY=${EPREFIX}$(java-config-2 -o)/jre/lib/${ABI}/libjawt.so
		-DJAVA_JVM_LIBRARY=${EPREFIX}$(java-config-2 -o)/jre/lib/${ABI}/server/libjvm.so
		-DRUN_SWIG=ON"

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_make bindings_java
}

src_test() {
	cd scripts/java || die
	einfo "Running test: ${S}/scripts/java/OBTest.java"
	CLASSPATH="openbabel.jar" LD_LIBRARY_PATH="${S}/$(get_libdir)" javac OBTest.java || die
	CLASSPATH=".:openbabel.jar" LD_LIBRARY_PATH="${S}/$(get_libdir)" java OBTest || die
}

src_install() {
	# Let cmake take care of RPATH setting and the like
	cmake -DCOMPONENT=bindings_java -P cmake_install.cmake

	java-pkg_dojar "${S}/$(get_libdir)/openbabel.jar"
	java-pkg_doso "${S}/$(get_libdir)/libopenbabel_java.so"
}
