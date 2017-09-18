# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_4,3_6} )

inherit distutils-r1 git-r3

DESCRIPTION="Collect academic articles from various APIs."
HOMEPAGE="https://github.com/ArcasProject/Arcas"
EGIT_REPO_URI="https://github.com/ArcasProject/Arcas"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	"
RDEPEND="
	dev-python/docopt[${PYTHON_USEDEP}]
	=dev-python/hypothesis-3.6.0-r1[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/ratelimit[${PYTHON_USEDEP}]
	>=dev-python/requests-2.12.1[${PYTHON_USEDEP}]
	dev-python/requests-mock[${PYTHON_USEDEP}]
	"

python_test() {
	"${PYTHON}" setup.py test || die
}
