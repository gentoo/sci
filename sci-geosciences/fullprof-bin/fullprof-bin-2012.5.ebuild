# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="Fullprof is a set of crystallographic programs (FullProf, WinPLOTR,
EdPCR, GFourier, etc...) mainly developed for Rietveld analysis of powder patterns"

HOMEPAGE="http://www.ill.eu/sites/fullprof/index.html"
SRC_URI="http://www.ill.eu/sites/fullprof/downloads/FullProf_Suite_May2012_Lin.tgz"
LICENSE="freedist HPND"
# There is no clear license specified. But according to Docs/Readme_Fp_Suite.txt
# those two seem to be appropriate.
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+X"

RDEPEND="X? ( >=x11-libs/motif-2.3 )"

S="${WORKDIR}/"
BASEDIR="/opt/fullprof"

src_install() {
        echo "FULLPROF=\"${BASEDIR}\"" > 99fullprof
        echo "PATH=\"${BASEDIR}\"" >> 99fullprof
        doenvd 99fullprof
        rm 99fullprof || die
        mkdir -p "${D}/${BASEDIR}" || die
        mv "${S}"/* "${D}/${BASEDIR}" || die
}
