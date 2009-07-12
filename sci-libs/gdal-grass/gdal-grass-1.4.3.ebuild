# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/gdal/gdal-1.6.0-r1.ebuild,v 1.1 2009/04/25 06:08:09 nerdboy Exp $

inherit eutils

DESCRIPTION="GDAL plugin to access GRASS data"
HOMEPAGE="http://www.gdal.org/"
SRC_URI="http://download.osgeo.org/gdal/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="debug"

RDEPEND="sci-libs/gdal
	sci-geosciences/grass"

DEPEND="${RDEPEND}"

src_unpack() {
    unpack ${A}
    cd "${S}"
    epatch "${FILESDIR}/${PN}-makefile.patch"
}

src_compile() {
	GRASS_ENVD="/etc/env.d/99grass /etc/env.d/99grass-6 /etc/env.d/99grass-cvs";
                for file in ${GRASS_ENVD}; do
                        if test -r ${file}; then
                                GRASSPATH=$(sed -n 's/LDPATH="\(.*\)\/lib"$/\1/p' ${file});
                        fi
                done

	econf --with-grass=${GRASSPATH} --with-gdal
	emake
}

src_install() {
	#pass the right variables to 'make install' to prevent a sandbox access violation
	emake DESTDIR="${D}" \
	GRASSTABLES_DIR="${D}$(gdal-config --prefix)/share/gdal/grass" \
	AUTOLOAD_DIR="${D}/usr/lib/gdalplugins" install || die "make install failure"
}
