# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/amos/amos-2.0.8.ebuild,v 1.2 2009/03/15 17:58:50 maekke Exp $

EAPI=2

DESCRIPTION="RNA-RNA interaction search"
HOMEPAGE="http://www.tbi.univie.ac.at/~htafer/"
SRC_URI="http://www.tbi.univie.ac.at/~htafer/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}
