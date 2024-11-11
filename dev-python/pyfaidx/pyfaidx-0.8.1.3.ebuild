# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Efficient pythonic random access to fasta subsequences"
HOMEPAGE="https://github.com/mdshw5/pyfaidx"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REPEND="dev-python/importlib_metadata[${PYTHON_USEDEP}]"

EPYTEST_DESELECT=(
	# needs external file
	tests/test_Fasta_bgzip.py
)

distutils_enable_tests pytest
