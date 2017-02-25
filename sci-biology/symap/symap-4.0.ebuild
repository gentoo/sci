# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Synteny Mapping and Analysis Program"
HOMEPAGE="http://www.agcol.arizona.edu/software/symap/"
SRC_URI="symap_40.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
#KEYWORDS="~x86 ~amd64"
IUSE=""

RESTRICT="fetch"

pkg_nofetch() {
	elog "Please register and download symap_${PV}.tar.gz (110MB)"
	elog "at http://www.agcol.arizona.edu/software/symap/v${PV}/download/"
	elog "and place it in ${DISTDIR}"
}

DEPEND="
	sci-biology/blat
	sci-biology/mummer
	sci-biology/muscle"
RDEPEND="${DEPEND}
	virtual/jre"
