# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 )

inherit distutils-r1

DESCRIPTION="Modules to convert numbers to words."
HOMEPAGE="https://github.com/savoirfairelinux/num2words"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/docopt[${PYTHON_USEDEP}]"

BDEPEND="
	test? ( dev-python/delegator[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest
