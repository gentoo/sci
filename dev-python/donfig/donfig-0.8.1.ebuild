# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

DESCRIPTION="Configure a package including defaults, env variable loading, and yaml loading"
HOMEPAGE=https://donfig.readthedocs.io/en/latest/
SRC_URI="https://github.com/pytroll/donfig/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		dev-python/cloudpickle[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
