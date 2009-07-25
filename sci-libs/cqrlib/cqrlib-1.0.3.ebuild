# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit base flag-o-matic toolchain-funcs

MY_PN=CQRlib
MY_P="${MY_PN}-${PV}"

DESCRIPTION="An ANSI C implementation of a utility library for quaternion arithmetic and quaternion rotation math"
HOMEPAGE="http://cqrlib.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/cvector"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}

PATCHES=(
	"${FILESDIR}"/${PV}-LDFLAGS.patch
	)

src_compile() {
	append-flags -ansi
	emake \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		CFLAGS="${CFLAGS}" \
		all || die
}

src_test() {
	emake tests || die "test failed"
}

src_install() {
	dobin bin/* || die "failed to install bins"
	dolib.a lib/.libs/*.a || die "failed to install libs"

	insinto /usr/include
	doins *.h || die "failed to install includes"

	dodoc README_CQRlib.txt
}
