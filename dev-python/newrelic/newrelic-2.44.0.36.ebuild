# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

MY_PN="newrelic"

DESCRIPTION="New Relic Python Agent"
HOMEPAGE="http://newrelic.com/docs/python/new-relic-for-python"

SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64"

LICENSE="newrelic"
SLOT="0"

RDEPEND="
	|| (
		dev-python/bottle[${PYTHON_USEDEP}]
		dev-python/cherrypy[${PYTHON_USEDEP}]
		dev-python/django[${PYTHON_USEDEP}]
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/pylons[${PYTHON_USEDEP}]
		dev-python/pyramid[${PYTHON_USEDEP}]
	)"
	#|| (
	#	dev-python/cython[${PYTHON_USEDEP}]
	#	virtual/pypy
	#	virtual/pypy3
	#)"
DEPEND="${RDEPEND}"
