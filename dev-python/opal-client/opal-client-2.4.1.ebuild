# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-r1 versionator

MY_PN="${PN/client/py}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python Opal Web Service Client"
HOMEPAGE="http://www.nbcr.net/data/docs/opal/documentation.html"
SRC_URI="mirror://sourceforge/opaltoolkit/opal-python/$(get_version_component_range 1-2)/${MY_P}.tar.gz"

LICENSE="opal"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-python/zsi-2.1_alpha1[${PYTHON_USEDEP}]
	!=sci-chemistry/apbs-1.1.0"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}

src_install() {
	"${EPREFIX}"/usr/bin/wsdl2py  wsdl/opal.wsdl || die

	python_moduleinto AppService
	python_foreach_impl python_domodule AppService_*.py
	python_foreach_impl python_optimize

	dodoc README CHANGELOG etc/* *Client.py
	dohtml docs/*
}
