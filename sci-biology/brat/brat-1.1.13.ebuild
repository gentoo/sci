# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/bfast/bfast-0.6.4c.ebuild,v 1.1 2010/05/07 19:21:57 weaver Exp $

EAPI="2"

DESCRIPTION="Bisulfite-treated Reads Analysis Tool"
HOMEPAGE="http://compbio.cs.ucr.edu/brat/"
SRC_URI="http://compbio.cs.ucr.edu/brat/downloads/brat-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

src_install() {
	dobin brat brat-large acgt-count trim brat-large-build || die
	dodoc BRAT_USER_MANUAL_${PV//./_}.pdf || die
}
