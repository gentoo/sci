# Copyright 1999-2025 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=uv-build
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

DESCRIPTION="A YAML template engine with Python expressions"
HOMEPAGE="https://pypi.org/project/yte/"
SRC_URI="https://github.com/yte-template-engine/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/argparse-dataclass[${PYTHON_USEDEP}]
	dev-python/dpath[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
