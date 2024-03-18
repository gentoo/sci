# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A Computer algebra package for Lie group computations"
HOMEPAGE="http://www-math.univ-poitiers.fr/~maavl/LiE/" # no https, invalid certificate
SRC_URI="http://wwwmathlabo.univ-poitiers.fr/~maavl/LiE/conLiE.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/LiE"

LICENSE="LGPL-2.1"
##### See http://packages.debian.org/changelogs/pool/main/l/lie/lie_2.2.2+dfsg-1/lie.copyright
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	sys-libs/readline:=
	sys-libs/ncurses:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/bison
"

PATCHES=( "${FILESDIR}"/${P}-debian.patch )

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	default
	use doc && dodoc "${S}"/manual/
}
