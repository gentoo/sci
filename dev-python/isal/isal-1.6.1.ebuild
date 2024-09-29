# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Faster zlib, gzip compatible (de)compression using ISA-L library"
HOMEPAGE="https://github.com/pycompression/python-isal https://pypi.org/project/isal"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

DOCS="README.rst"

distutils_enable_sphinx doc \
	dev-python/sphinx-rtd-theme

distutils_enable_tests pytest
