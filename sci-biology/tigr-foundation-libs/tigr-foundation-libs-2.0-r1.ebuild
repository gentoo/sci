# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="TIGR Foundation for C++"
HOMEPAGE="http://sourceforge.net/apps/mediawiki/amos/index.php?title=AutoEditor"
SRC_URI="ftp://ftp.cbcb.umd.edu/pub/software/autoEditor/autoEditor-1.20.tar.gz"

# the one bundled in autoEditor-1.20/TigrFoundation-2.0/ is same with the one in bambus
# but in bambus-2.33/src/TIGR_Foundation_CC/ there are 3 getopt.* files in addition

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"/autoEditor-1.20/TigrFoundation-2.0

src_prepare(){
	epatch "${FILESDIR}"/TigrFoundation-all-patches.patch
	sed -i "s:/export/usr/local:${ED}/usr:g" Makefile || die
	default
}

src_install(){
	emake install DESTDIR="${D}/${EPREFIX}"/usr # Makefile does not respect DESTDIR
}
