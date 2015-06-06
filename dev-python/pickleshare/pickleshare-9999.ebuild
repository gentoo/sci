# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 python{3_3,3_4} )

inherit distutils-r1

DESCRIPTION="A small 'shelve' like datastore with concurrency support"
HOMEPAGE="https://github.com/pickleshare/pickleshare"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git git://github.com/${PN}/${PN}.git"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64"
	# test_pickleshare.py is not included in the pickleshare-0.5 source
	# we fetched from pipy
	RESTRICT="test"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-python/path-py[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}"/lib || die
	cp "${S}"/test_pickleshare.py "${TEST_DIR}"/lib/ || die
	py.test || die
}
