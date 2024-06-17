# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Create MPS/LP files, call solvers, and present results"
HOMEPAGE="https://coin-or.github.io/pulp/"
SRC_URI="https://github.com/coin-or/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"

distutils_enable_tests setup.py
# ToDo: package theme
#distutils_enable_sphinx doc/source dev-python/sphinx_glpi_theme
