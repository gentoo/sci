# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PN="${PN/-bin}"

DESCRIPTION="prints various statistics (that are not available from XDS itself)"
HOMEPAGE="http://strucbio.biologie.uni-konstanz.de/xdswiki/index.php/XDSSTAT"
SRC_URI="ftp://turn5.biologie.uni-konstanz.de/pub/${MY_PN}.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-chemistry/xds-bin
	amd64? ( app-emulation/emul-linux-x86-baselibs )"
DEPEND=""

src_install() {
	exeinto /opt/${MY_PN}
	doexe ${MY_PN} || die

	cat >> "${T}"/40${MY_PN} <<- EOF
	PATH="/opt/${MY_PN}/"
	EOF

	doenvd "${T}"/40${MY_PN} || die
}
