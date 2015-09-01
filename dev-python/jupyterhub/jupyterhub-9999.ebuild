# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{3_3,3_4} )

inherit distutils-r1

DESCRIPTION="A multi-user server for Jupyter notebooks"
HOMEPAGE="http://jupyter.org"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jupyter/${PN}.git git://github.com/jupyter/${PN}.git"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="
	net-libs/configurable-http-proxy
	>=dev-python/ipython-4.0.0[notebook,${PYTHON_USEDEP}]
	dev-python/traitlets[${PYTHON_USEDEP}]
	>=www-servers/tornado-4.0.1[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/simplepam[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}"
