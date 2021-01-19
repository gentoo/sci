# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Adaptor and MID removal / trimming tool"
HOMEPAGE="https://sourceforge.net/projects/skewer"
SRC_URI="
	https://sourceforge.net/projects/skewer/files/Binaries/skewer-${PV}-linux-x86_64
	https://sourceforge.net/projects/skewer/files/Scripts/srna-scripts-0.1.2.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="${DEPEND}
	dev-lang/perl"

S="${WORKDIR}"

src_install() {
	cp "${DISTDIR}"/skewer-* skewer || die
	dobin *.pl skewer
}
