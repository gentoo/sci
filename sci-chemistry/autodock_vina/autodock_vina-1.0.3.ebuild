# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="AutoDock Vina is a new program for drug discovery and molecular docking"
HOMEPAGE="http://vina.scripps.edu/"
MY_PN="${PN}_${PV//./_}_linux_i386"
SRC_URI="http://vina.scripps.edu/download/${MY_PN}.tar.gz"
MY_S="${PN}_${PV//./_}_linux_i386"

LICENSE="vina_license"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="amd64? (
				app-emulation/emul-linux-x86-baselibs
				app-emulation/emul-linux-x86-compat
		)"

src_unpack() {
	unpack ${A}
	cd "${MY_S}"
	header=`grep --binary-files=text "header_length=" install.sh | cut -d "=" -f2`
	tail -n+${header} install.sh | tar -xz
}

src_install() {
	dobin	${MY_S}/vina
	dobin	${MY_S}/vina_split
}
