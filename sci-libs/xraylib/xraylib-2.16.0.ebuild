# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1
AUTOTOOLS_AUTORECONF=true
FORTRAN_NEEDED=fortran
FORTRAN_STANDARD=2003
PYTHON_COMPAT=( python{2_6,2_7} ) # python 3 supported by github master
inherit eutils autotools-utils python-single-r1 java-pkg-opt-2 fortran-2

DESCRIPTION="A library for X-ray matter interaction cross sections for X-ray fluorescence applications"
HOMEPAGE="https://github.com/tschoonj/xraylib"
SRC_URI="https://github.com/tschoonj/xraylib/archive/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples fortran java lua perl python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="${PYTHON_DEPS}
	java? ( virtual/jdk )
	lua? ( dev-lang/lua )
	perl? ( dev-lang/perl )"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${P}"

DOCS=(AUTHORS BUGS Changelog README TODO)

pkg_setup() {
	fortran-2_pkg_setup
	java-pkg-opt-2_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	autotools-utils_src_prepare
	java-pkg-opt-2_src_prepare
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
	if use fortran
	then # see https://github.com/tschoonj/xraylib/issues/11
		emake -j1
	else
		emake
	fi
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
}