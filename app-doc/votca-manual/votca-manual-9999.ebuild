# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit mercurial

EHG_REPO_URI="https://manual.votca.googlecode.com/hg"
S="${WORKDIR}/${EHG_REPO_URI##*/}"

DESCRIPTION="Manual for votca-csg"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="=sci-chemistry/votca-csg-${PV}
	virtual/latex-base
	dev-tex/pgf"

RDEPEND=""

src_compile() {
	#CSGSHARE is needed to find the scripts of csg_inverse
	emake CSGSHARE="/usr/share/votca" || die
}

#there is no make install rule
src_install() {
	insinto /usr/share/doc/votca-csg-${PV}
	newins manual.pdf manual-${PV}.pdf || die
}
