# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_13 pypy3 )
inherit distutils-r1 pypi

DESCRIPTION="Robust and effective logging for Python 2 and 3"
HOMEPAGE="https://pypi.org/project/logzero"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests pytest
