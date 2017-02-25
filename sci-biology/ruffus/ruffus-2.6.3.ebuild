# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python module to support computational pipelines"
HOMEPAGE="http://www.ruffus.org.uk"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
# git@github.com:bunbun/ruffus.git

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		media-gfx/graphviz"
RDEPEND="${DEPEND}"
