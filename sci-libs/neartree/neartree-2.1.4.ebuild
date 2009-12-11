# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit base flag-o-matic toolchain-funcs

MY_PN=NearTree
MY_P="${MY_PN}-${PV}"

DESCRIPTION="function library efficiently solving the Nearest Neighbor Problem(known as the post office problem)"
HOMEPAGE="http://neartree.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}/${MY_PN}.zip -> ${P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/cvector"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}"/${PV}-FLAGS.patch
	"${FILESDIR}"/${PV}-gcc4.3.patch
	"${FILESDIR}"/${PV}-iterator.patch
	"${FILESDIR}"/${PV}-test.patch
	)

src_prepare() {
	base_src_prepare
	sed \
		-e "s:GENTOOLIBDIR:$(get_libdir):g" \
		-i Makefile
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		all || die
}

src_test() {
	emake \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		tests || die
}

src_install() {
	dobin bin/* || die "failed to install bins"
	dolib.a lib/.libs/*.a || die "failed to install libs"

	insinto /usr/include
	doins *.h || die "failed to install includes"

	dodoc README_NearTree.txt
	dohtml *.html
}
