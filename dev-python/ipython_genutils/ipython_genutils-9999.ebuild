# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 python{3_3,3_4} )

inherit distutils-r1

MY_PN="ipython_genutils"

DESCRIPTION="Vestigial utilities from IPython"
HOMEPAGE="https://github.com/ipython/ipython_genutils"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ipython/${MY_PN}.git git://github.com/ipython/${PN}.git"
else
	SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"
IUSE="test"

DEPEND="test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_test() {
	nosetests --with-coverage --cover-package=ipython_genutils ipython_genutils || die
}
