# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/amos/amos-2.0.8.ebuild,v 1.1 2008/08/26 16:33:07 weaver Exp $

DESCRIPTION="An algorithm for finding genomic targets for microRNAs"
HOMEPAGE="http://www.microrna.org/"
SRC_URI="http://cbio.mskcc.org/microrna_data/miRanda-sept2008.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}"

src_install() {
	emake DESTDIR="${D}" install || die
}
