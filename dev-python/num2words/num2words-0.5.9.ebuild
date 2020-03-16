# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7} )

inherit distutils-r1

DESCRIPTION="Modules to convert numbers to words."
HOMEPAGE="https://github.com/savoirfairelinux/num2words"
SRC_URI="https://github.com/savoirfairelinux/num2words/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="
	test? ( dev-python/delegator[${PYTHON_USEDEP}] )
	"
RDEPEND=""

python_test() {
	${EPYTHON} setup.py test || die
}
