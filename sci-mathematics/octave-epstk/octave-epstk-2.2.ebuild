# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils

DEB_PR=14
DESCRIPTION="Graphical output functions for Matlab and Octave"
HOMEPAGE="http://www.epstk.de"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}-${DEB_PR}.diff.gz"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE=""

RDEPEND="sci-mathematics/octave
	app-text/ghostscript-gpl"
DEPEND=""

src_prepare() {
	epatch "${WORKDIR}"/${PN}_${PV}-${DEB_PR}.diff
	cd "${S}"
	mv "${WORKDIR}"/epstk*/* . || die
	for i in $(cat debian/patches/series); do
		epatch debian/patches/${i}
	done
}

src_install () {
	insinto /usr/share/octave/site/m/${PN}
	doins m/*.m m/*.psd m/epstkbc m/def* m/mFileList m/epsFileList m/octave.asc m/*.inc || die
	insinto /etc
	doins debian/epstk.conf || die
	dodoc debian/README.Debian debian/changelog
}

pkg_postinst () {
	einfo "Package installed as octave-epstk."
	einfo "To test epstk, run octave and execute the demo m files."
	einfo "For example:"
	einfo "octave:1> edemo1"
}
