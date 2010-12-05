# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

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

RDEPEND="
	>=dev-python/zsi-2.1_alpha1
	!=sci-chemistry/apbs-1.1.0"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}

src_prepare() {
	python_copy_sources
}

src_install() {
		"${EPREFIX}"/usr/bin/wsdl2py  wsdl/opal.wsdl || die

	installation() {
		insinto $(python_get_sitedir)/AppService
		doins AppService_*.py || die
	}
	python_execute_function -s installation

	dodoc README CHANGELOG etc/* *Client.py || die
	dohtml docs/* || die
}

pkg_postinst() {
	python_mod_optimize AppService
}

pkg_postrm() {
	python_mod_cleanup AppService
}
