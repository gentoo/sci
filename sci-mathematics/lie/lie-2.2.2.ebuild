# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="A Computer algebra package for Lie group computations"
HOMEPAGE="http://www-math.univ-poitiers.fr/~maavl/LiE/"
SRC_URI="http://wwwmathlabo.univ-poitiers.fr/~maavl/LiE/conLiE.tar.gz -> ${P}.tar.gz"
#### Remove the following line when moving this ebuild to the main tree!
RESTRICT="mirror"

LICENSE="LGPL-2.1"
##### See http://packages.debian.org/changelogs/pool/main/l/lie/lie_2.2.2+dfsg-1/lie.copyright
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="
	sys-devel/bison
	sys-libs/readline:0=
	sys-libs/ncurses:0="
RDEPEND="sys-libs/readline:=
	sys-libs/ncurses"

S="${WORKDIR}/LiE"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-make.patch \
		"${FILESDIR}"/parrallelmake-${P}.patch
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	default
	use doc && dodoc "${S}"/manual/*
}

pkg_postinst() {
	elog "This version of the LiE ebuild is still under development."
	elog "Help us improve the ebuild in:"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=194393"
}
