# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit pypi distutils-r1

DESCRIPTION="String encoding/decoding of binary data"
HOMEPAGE="https://pypi.org/project/lzstring/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"
