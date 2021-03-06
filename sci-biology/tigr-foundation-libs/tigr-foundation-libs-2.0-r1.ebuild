# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="TIGR Foundation for C++"
HOMEPAGE="https://sourceforge.net/projects/amos/"
SRC_URI="ftp://ftp.cbcb.umd.edu/pub/software/autoEditor/autoEditor-1.20.tar.gz"

# the one bundled in autoEditor-1.20/TigrFoundation-2.0/ is same with the one in bambus
# but in bambus-2.33/src/TIGR_Foundation_CC/ there are 3 getopt.* files in addition

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/autoEditor-1.20/TigrFoundation-2.0"

PATCHES=(
	"${FILESDIR}/TigrFoundation-all-patches.patch"
)

src_prepare(){
	sed -i "s:/export/usr/local:${ED}/usr:g" Makefile || die
	default
}

src_install(){
	emake install DESTDIR="${ED}/usr" # Makefile does not respect DESTDIR
}
