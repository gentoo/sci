# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

DESCRIPTION="Painlessly create beautiful matplotlib plots"
HOMEPAGE="http://blog.olgabotvinnik.com/prettyplotlib/"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/olgabot/${PN}.git git://github.com/olgabot/${PN}.git"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="
	sci-libs/scipy[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-1.4.0[${PYTHON_USEDEP}]
	dev-python/brewer2mpl[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
