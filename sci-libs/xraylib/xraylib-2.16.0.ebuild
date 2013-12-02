# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_6 python2_7 python3_1 python3_2 python3_3 )
inherit eutils autotools-utils python-r1

DESCRIPTION="A library for X-ray matter interaction cross sections for X-ray fluorescence applications"
HOMEPAGE="https://github.com/tschoonj/xraylib"
SRC_URI="https://github.com/tschoonj/xraylib/archive/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cxx examples fortran java lua perl php python ruby"

DEPEND="fortran? ( virtual/fortran )
	java? ( virtual/jdk )
	lua? ( dev-lang/lua )
	perl? ( dev-lang/perl )
	${PYTHON_DEPS}"

RDEPEND="${DEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD=1

S="${WORKDIR}/${PN}-${P}"

DOCS=(AUTHORS BUGS ChangeLog README TODO)

src_configure() {
	local myeconfargs=(
		--disable-idl
		$(use-enable fortran fortran2003)
		$(use-enable java)
		$(use-enable lua)
		$(use-enable perl)
		$(use-enable perl perl-integration)
		$(use-enable php)
		$(use-enable php php-integration)
		$(use-enable python)
		$(use-enable python python-integration)
		$(use-enable ruby)
		$(use-enable ruby ruby-integration)
	)
	autotools-utils_src_configure
}
