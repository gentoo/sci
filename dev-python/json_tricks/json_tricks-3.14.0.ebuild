# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

MY_HASH="895ef50d8d9882e8030005103a205b2b5f169721ac5b3f265847da07729f"

DESCRIPTION="Extra features for Python's JSON"
HOMEPAGE="https://github.com/mverleg/pyjson_tricks"
SRC_URI="mirror://pypi/../be/05/${MY_HASH}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

RDEPEND=""

DEPEND=""

distutils_enable_tests pytest
