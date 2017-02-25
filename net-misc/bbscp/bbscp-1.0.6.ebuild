# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="SCP-like interface to bbFTP"
HOMEPAGE="http://www.nas.nasa.gov/Users/Documentation/Networks/BBSCP/bbscp.html"
SRC_URI="http://www.nas.nasa.gov/hecc/support/kb/file/4/ -> ${P}.tar.gz"

LICENSE="NOSA"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	net-ftp/bbftp-client"

src_install() {
	dobin ${PN}
	dodoc NOSA.txt
	doman man/bbscp.1
}
