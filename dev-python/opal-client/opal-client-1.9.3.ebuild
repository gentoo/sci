# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python

MY_PN="${PN/client/py}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python Opal Web Service Client"
HOMEPAGE="http://nbcr.net/software/opal/"
SRC_URI="mirror://sourceforge/opaltoolkit/${MY_P}.tar.gz"

LICENSE="opal"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/zsi-2.1.0_alpha1
	!=sci-chemistry/apbs-1.1.0"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}

src_install() {
	/usr/bin/wsdl2py  wsdl/opal.wsdl || die

	insinto $(python_get_sitedir)
	doins AppService_*.py || die
	dodoc README CHANGELOG etc/* *Client.py || die
	dohtml docs/* || die
}
