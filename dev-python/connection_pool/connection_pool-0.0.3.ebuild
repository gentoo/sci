# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Thread safe connection pool"
HOMEPAGE="https://github.com/zhouyl/ConnectionPool"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
