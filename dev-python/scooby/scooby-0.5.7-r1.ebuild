# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_12 )
inherit distutils-r1 pypi

DESCRIPTION="Easily report Python package versions and hardware resources"
HOMEPAGE="https://pypi.org/project/scooby/"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0"
