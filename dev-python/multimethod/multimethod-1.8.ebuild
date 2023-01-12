# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_10 )

inherit distutils-r1

DESCRIPTION="Library allowing Python function overloads based on argument types"
HOMEPAGE="https://github.com/coady/multimethod"

SRC_URI="https://github.com/coady/multimethod/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"

distutils_enable_tests pytest
