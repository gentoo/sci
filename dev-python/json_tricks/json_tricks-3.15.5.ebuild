# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Extra features for Python's JSON"
HOMEPAGE="https://github.com/mverleg/pyjson_tricks"
SRC_URI="https://github.com/mverleg/pyjson_tricks/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/py${PN}-${PV}"

distutils_enable_tests pytest
distutils_enable_sphinx docs
