# Copyright 1999-2026 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="Declarative CLIs with argparse and dataclasses"
HOMEPAGE="https://pypi.org/project/argparse-dataclass/"
SRC_URI="https://github.com/mivade/argparse_dataclass/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN//-/_}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	epytest --doctest-modules argparse_dataclass.py tests
}
