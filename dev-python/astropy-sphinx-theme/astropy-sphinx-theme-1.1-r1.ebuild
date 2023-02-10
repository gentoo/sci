# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="The sphinx theme for Astropy and affiliated packages"
HOMEPAGE="https://github.com/astropy/astropy-sphinx-theme"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests pytest
