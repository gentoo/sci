# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{6,7} pypy{,3} )

inherit distutils-r1

DESCRIPTION="Sphinx extension for documenting Java projects"
HOMEPAGE="https://github.com/bronto/javasphinx"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-solaris"

RDEPEND="
	>=dev-python/javalang-0.10.1
	dev-python/lxml
	dev-python/beautifulsoup:4
	dev-python/future
	dev-python/docutils
	dev-python/namespace-sphinxcontrib"

# avoid circular dependency with sphinx
PDEPEND="
	>=dev-python/sphinx-1.5.3"

DEPEND="
	${RDEPEND}
	${PDEPEND}
	dev-python/setuptools"
