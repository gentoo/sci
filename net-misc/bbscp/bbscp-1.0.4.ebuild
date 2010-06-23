# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="bbSCP is a wrapper that provides an SCP-like interface to bbFTP."

HOMEPAGE="http://www.nas.nasa.gov/Users/Documentation/Networks/BBSCP/bbscp.html"
SRC_URI="http://www.nas.nasa.gov/Users/Documentation/Networks/BBSCP/${P}.tar.gz"

LICENSE="NOSA"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND} net-ftp/bbftp-client"

src_install() {
	dobin bbscp
	dodoc NOSA.txt COPYING.txt
	doman man/bbscp.1
}
