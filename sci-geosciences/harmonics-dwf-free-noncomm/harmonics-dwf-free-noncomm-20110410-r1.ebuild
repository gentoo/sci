# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Tidal harmonics database for libtcd."
HOMEPAGE="http://www.flaterco.com/xtide/"

MY_P="${P/-free-noncomm-/-}"

# Even though the SRC_URI is labeled nonfree, the data is actually available for
# any non-commercial use.
SRC_URI="ftp://ftp.flaterco.com/xtide/${MY_P}-nonfree.tar.bz2"
LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	insinto /usr/share/harmonics
	doins "${WORKDIR}/${MY_P}"-nonfree.tcd
}
