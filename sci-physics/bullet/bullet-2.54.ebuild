# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

DESCRIPTION="Continuous Collision Detection and Physics Library"
HOMEPAGE="http://www.continuousphysics.com/Bullet/"
SRC_URI="mirror://sourceforge/bullet/${P}.tgz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test doc examples"

RDEPEND="examples? ( virtual/opengl )"
DEPEND="${DEPEND}
	dev-util/jam"
#	test? ( dev-util/cppunit )"

src_compile() {
	econf \
		$(use_with examples x) \
		$(use_with examples mesa) \
		|| die "econf failed"
	jam ${MAKEOPTS} || die "jam failed"
}

#src_test() {
#	jam check || die "jam check failed"
#}

src_install() {
	jam -sDESTDIR="${D}" install || die "jam install failed"
	dodoc README ChangeLog.txt AUTHORS
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins *.pdf
	fi
}
