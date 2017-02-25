# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN="${PN%-bin}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Pairwise sequence alignment mapping DNA reads onto genomic reference"
HOMEPAGE="http://www.sanger.ac.uk/resources/software/smalt/"
SRC_URI="ftp://ftp.sanger.ac.uk/pub4/resources/software/${MY_PN}/${MY_P}.tgz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"/${MY_P}

QA_PREBUILT="/opt/.*"

src_install(){
	exeinto /opt/bin
	use x86 && newexe ${MY_PN}_i386 ${MY_PN}
	use amd64 && newexe ${MY_PN}_x86_64 ${MY_PN}
	use ia64 && newexe ${MY_PN}_ia64 ${MY_PN}

	dodoc NEWS ${MY_PN}_manual.pdf
	doman ${MY_PN}.1
}
