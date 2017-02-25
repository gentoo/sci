# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Tools for bioinformatics (notably Tallymer, Readjoiner, gff3validator)"
HOMEPAGE="http://genometools.org"
SRC_URI="http://genometools.org/pub/${P}.tar.gz"

LICENSE="ICS"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-libs/glib
	x11-libs/pango
	x11-libs/cairo"
RDEPEND="${DEPEND}"

src_prepare(){
	sed -e "s#/usr/local#"${EPREFIX}"/usr#" -i Makefile || die
	eapply_user
}
