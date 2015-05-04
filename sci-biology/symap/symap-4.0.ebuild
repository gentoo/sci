# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Synteny Mapping and Analysis Program between chromosomes, contigs and physical maps"
HOMEPAGE="http://www.agcol.arizona.edu/software/symap/"
SRC_URI="symap_40.tar.gz"

LICENSE="GPLv2-symap"
SLOT="0"
KEYWORDS=""
#KEYWORDS="~x86 ~amd64"
IUSE=""

RESTRICT="fetch"

pkg_nofetch() {
        einfo "Please register and download symap_${PV}.tar.gz (110MB)"
        einfo "at http://www.agcol.arizona.edu/software/symap/v"${PV}"/download/"
        einfo 'and place it in '${DISTDIR}
}


DEPEND="sci-biology/blat
	sci-biology/mummer
	sci-biology/muscle"
RDEPEND="${DEPEND}
	dev-lang/java"

