# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit base mercurial

EHG_REPO_URI="https://code.google.com/p/votca.csg-manual/"

DESCRIPTION="Manual for votca-csg"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-macos"
IUSE=""

DEPEND="
	|| (
		(
			=sci-chemistry/${PN%-manual}-${PV}[extras]
			=sci-chemistry/${PN%-manual}apps-${PV}
		)
		=sci-chemistry/${PN%-manual}-${PV}[-extras]
	)
	dev-texlive/texlive-latexextra
	virtual/latex-base
	dev-tex/pgf"

RDEPEND=""

src_install() {
	insinto /usr/share/doc/${PN%-manual}-${PV}
	newins manual.pdf manual-${PV}.pdf || die
}
