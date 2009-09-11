# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/fasttree/fasttree-2.0.1.ebuild,v 1.1 2009/09/10 23:14:22 weaver Exp $

EAPI="2"

DESCRIPTION="Rapid reconstruction of phylogenies by the Neighbor-Joining method"
HOMEPAGE="http://www.sanger.ac.uk/Software/analysis/quicktree/"
SRC_URI="http://www.sanger.ac.uk/Software/analysis/quicktree/quicktree_${PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}_${PV}"

src_install() {
	dobin bin/quicktree || die
	dodoc README
}
