# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit pypi distutils-r1

DESCRIPTION="Declarative CLIs with argparse and dataclasses"
HOMEPAGE="https://pypi.org/project/argparse-dataclass/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test" # no tests collected
#distutils_enable_tests pytest
