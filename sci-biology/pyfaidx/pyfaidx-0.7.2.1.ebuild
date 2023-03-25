# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Efficient pythonic random access to fasta subsequences"
HOMEPAGE="https://pypi.python.org/pypi/pyfaidx https://github.com/mdshw5/pyfaidx"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
# Test issues reported upstream:
# https://github.com/mdshw5/pyfaidx/issues/208
RESTRICT="test"

REPEND="dev-python/six[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
