# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Create MPS/LP files, call solvers, and present results"
HOMEPAGE="http://pulp-or.googlecode.com/"
SRC_URI="https://github.com/coin-or/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="dev-python/amply[${PYTHON_USEDEP}]"

distutils_enable_tests setup.py
# ToDo: package theme
#distutils_enable_sphinx doc/source dev-python/sphinx_glpi_theme
