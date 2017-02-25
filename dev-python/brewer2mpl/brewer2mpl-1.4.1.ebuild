# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

DESCRIPTION="Connect colorbrewer2.org color maps to Python and matplotlib"
HOMEPAGE="https://github.com/jiffyclub/brewer2mpl"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jiffyclub/${PN}.git git://github.com/jiffyclub/${PN}.git"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="dev-python/matplotlib[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
