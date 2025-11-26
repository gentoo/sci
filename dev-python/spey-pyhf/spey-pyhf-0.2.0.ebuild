# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
inherit distutils-r1

DESCRIPTION="pyhf plugin for spey interface"
HOMEPAGE="
	https://github.com/SpeysideHEP/spey-pyhf/
	https://speysidehep.github.io/spey-pyhf/
	https://arxiv.org/abs/2307.06996
"

SRC_URI="https://github.com/SpeysideHEP/spey-pyhf/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	~sci-physics/pyhf-0.7.6[${PYTHON_USEDEP}]
	>=dev-python/spey-0.2.1[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}"
