# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..13} )
PYPI_NO_NORMALIZE=1
PYPI_PN=delegator.py
inherit distutils-r1 pypi

DESCRIPTION="Subprocesses for Humans 2.0."
HOMEPAGE="https://github.com/amitt001/delegator.py"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/pexpect[${PYTHON_USEDEP}]"

S="${WORKDIR}/${PN}.py-${PV}"
