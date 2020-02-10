# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{5,6,7} pypy{,3} )

inherit distutils-r1

DESCRIPTION="Sphinx extension using KaTeX to render math in HTML"
HOMEPAGE="https://github.com/hagenw/sphinxcontrib-katex"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-solaris"

RDEPEND="
	dev-python/namespace-sphinxcontrib"

# avoid circular dependency with sphinx
PDEPEND="
	>=dev-python/sphinx-1.6"
DEPEND="
	${RDEPEND}
	${PDEPEND}
	dev-python/setuptools"

python_install_all() {
	distutils-r1_python_install_all
	find "${ED}" -name '*.pth' -delete || die
}