# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN%-bin}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Pairwise sequence alignment mapping DNA reads onto genomic reference"
HOMEPAGE="https://sourceforge.net/projects/smalt/"
SRC_URI="https://sourceforge.net/projects/${MY_PN}/files/${MY_P}-bin.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${MY_P}-bin"

QA_PREBUILT="/opt/.*"

src_install(){
	exeinto /opt/bin
	use x86 && newexe ${MY_PN}_i386 ${MY_PN}
	use amd64 && newexe ${MY_PN}_x86_64 ${MY_PN}
	use ia64 && newexe ${MY_PN}_ia64 ${MY_PN}

	dodoc NEWS ${MY_PN}_manual.pdf
	doman ${MY_PN}.1
}
