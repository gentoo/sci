# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit base mercurial

EHG_REPO_URI="https://manual.votca.googlecode.com/hg"
EHG_REVISION="default"
S="${WORKDIR}/${EHG_REPO_URI##*/}"

DESCRIPTION="Manual for votca-csg"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
	|| (
		(
			=sci-chemistry/${PN%-manual}-${PV}[extras]
			=sci-chemistry/${PN%-manual}apps-${PV}
		)
		=sci-chemistry/${PN%-manual}-${PV}[-extras]
	)
	virtual/latex-base
	dev-tex/pgf"

RDEPEND=""

src_install() {
	insinto /usr/share/doc/${PN%-manual}-${PV}
	newins manual.pdf manual-${PV}.pdf || die
}
