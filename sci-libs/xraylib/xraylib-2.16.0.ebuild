# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=true
FORTRAN_NEEDED=fortran
FORTRAN_STANDARD=2003
PYTHON_COMPAT=( python2_7 ) # python 3 supported by github master

inherit eutils autotools-utils python-single-r1 java-pkg-opt-2 fortran-2

DESCRIPTION="X-ray matter interaction cross sections for X-ray fluorescence library"
HOMEPAGE="https://github.com/tschoonj/xraylib"
SRC_URI="https://github.com/tschoonj/xraylib/archive/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples fortran java lua perl python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	java? ( >=virtual/jre-1.4:* )
	lua? ( dev-lang/lua:0 )
	perl? ( dev-lang/perl )
	python? ( ${PYTHON_DEPS} )"

DEPEND="${RDEPEND}
	java? ( >=virtual/jdk-1.4:* )"

S="${WORKDIR}/${PN}-${P}"

DOCS=(AUTHORS BUGS Changelog README TODO)

pkg_setup() {
	fortran-2_pkg_setup
	java-pkg-opt-2_pkg_setup
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	java-pkg-opt-2_src_prepare
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--disable-idl
		$(use_enable fortran fortran2003)
		$(use_enable java)
		$(use_enable lua)
		$(use_enable perl)
		$(use_enable python)
		$(use_enable python python-integration)
	)
	autotools-utils_src_configure
}

src_compile() {
	# see https://github.com/tschoonj/xraylib/issues/11
	if use fortran || use java; then
		MAKEOPTS+=" -j1"
	fi
	autotools-utils_src_compile
}

src_install() {
	autotools-utils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins example/*.c example/*.cpp
		use java && doins example/*.java
		use lua && doins example/*.lua
		use perl && doins example/*.pl
		use python && doins example/*.py
		docompress -x /usr/share/doc/${PF}/examples # Don't compress examples
	fi

	use java && java-pkg_regso /usr/share/xraylib/java/libxraylib.so
}
