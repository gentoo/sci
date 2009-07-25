# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit base flag-o-matic toolchain-funcs

MY_PN=NearTree
MY_P="${MY_PN}-${PV}"

DESCRIPTION="function library efficiently solving the Nearest Neighbor Problem(known as the post office problem)"
HOMEPAGE="http://neartree.sourceforge.net"
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
	"${FILESDIR}"/${PV}-gcc4.3.patch
	)

src_compile() {
	append-flags -DCNEARTREE_SAFE_TRIANG=1 -ansi
	emake \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		CFLAGS="${CFLAGS}" \
		all || die
}

src_install() {
	dobin bin/* || die "failed to install bins"
	dolib.a lib/.libs/*.a || die "failed to install libs"

	insinto /usr/include
	doins *.h || die "failed to install includes"

	dodoc README_NearTree.txt
}
