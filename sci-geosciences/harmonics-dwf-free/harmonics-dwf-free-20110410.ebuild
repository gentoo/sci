# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="${P/-free-/-}"

DESCRIPTION="Tidal harmonics database for libtcd."
HOMEPAGE="http://www.flaterco.com/xtide/"
SRC_URI="ftp://ftp.flaterco.com/xtide/${MY_P}-free.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	insinto /usr/share/"${PN}"
	doins "${WORKDIR}/${MY_P}"-free.tcd
	tcd_paths=`find /usr/share/harmonics-* -name '*.tcd'`
	echo -n 'HFILE_PATH=' > 50xtide_harm
	for t in ${tcd_paths}; do
		echo -n ${t} >> 50xtide_harm
		echo -n ':' >> 50xtide_harm
	done
	doenvd 50xtide_harm
}
