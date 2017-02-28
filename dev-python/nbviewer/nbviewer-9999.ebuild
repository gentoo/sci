# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python3_{4,5} )

inherit distutils-r1 git-r3

DESCRIPTION="Nbconvert as a webservice (rendering ipynb to static HTML)"
HOMEPAGE="http://jupyter.org"
EGIT_REPO_URI="https://github.com/jupyter/${PN}.git git://github.com/jupyter/${PN}.git"

LICENSE="BSD-4"
SLOT="0"

RDEPEND="
	>=dev-python/ipython-4.0.0[notebook,${PYTHON_USEDEP}]
	>=www-servers/tornado-3.1.1[${PYTHON_USEDEP}]
	dev-python/pycurl[${PYTHON_USEDEP}]
	dev-python/pylibmc[${PYTHON_USEDEP}]
	dev-python/newrelic[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/elasticsearch-py[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}"
