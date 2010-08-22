# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils toolchain-funcs

DESCRIPTION="A Computer algebra package for Lie group computations"
HOMEPAGE="http://young.sp2mi.univ-poitiers.fr/~marc/LiE"
SRC_URI="http://young.sp2mi.univ-poitiers.fr/~marc/LiE/conLiE.tar.gz"
#### Remove the following line when moving this ebuild to the main tree!
RESTRICT="mirror"

LICENSE="LGPL-2.1"
##### See http://packages.debian.org/changelogs/pool/main/l/lie/lie_2.2.2+dfsg-1/lie.copyright

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"
DEPEND="sys-devel/bison
	sys-libs/readline
	sys-libs/ncurses"
RDEPEND="sys-libs/readline
	sys-libs/ncurses"

S="${WORKDIR}/LiE"

src_prepare() {
	epatch "${FILESDIR}/${P}-make.patch"
	epatch "${FILESDIR}/parrallelmake-${P}.patch"
}

src_compile() {
	emake CC=$(tc-getCC) || die "failed to compile"
}

src_install() {
	emake DESTDIR="${ED}" install || die
	use doc && dodoc "${S}"/manual/*
	dodoc README
}

pkg_postinst() {
	elog "This version of the LiE ebuild is still under development."
	elog "Help us improve the ebuild in:"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=194393"
}
