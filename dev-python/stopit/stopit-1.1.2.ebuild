# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Timeout control decorator and context managers"
HOMEPAGE="https://pypi.org/project/stopit"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
