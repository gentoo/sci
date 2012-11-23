# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="a set of crystallographic tools mainly for Rietveld analysis"
HOMEPAGE="http://www.ill.eu/sites/fullprof/index.html"
SRC_URI="http://www.ill.eu/sites/fullprof/downloads/FullProf_Suite_May2012_Lin.tgz"
LICENSE="freedist HPND"
# There is no clear license specified. But according to Docs/Readme_Fp_Suite.txt
# those two seem to be appropriate.
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+X +doc +examples"

RDEPEND="X? ( >=x11-libs/motif-2.3 )"

S="${WORKDIR}/"

src_install() {
        BASEDIR="/opt/fullprof"
        echo "FULLPROF=\"${BASEDIR}\"" > 99fullprof
        echo "PATH=\"${BASEDIR}\"" >> 99fullprof
        doenvd 99fullprof
        rm 99fullprof || die
        if use !examples; then
          rm -r Examples || die
        fi
        if use !doc; then
          rm -r Docs || die
          rm -r Html || die
        else
          # fix html documentation to actually work
          ls Docs/*.HTM | while read file
          do
            mv $file `echo $file | sed 's/\/.*/\L&/'`
          done
        fi
        mkdir -p "${D}/${BASEDIR}" || die
        mv "${S}"/* "${D}/${BASEDIR}" || die
}
