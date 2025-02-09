# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

DOCS_BUILDER="sphinx"
DOCS_DEPEND="dev-python/numpydoc"
DOCS_DIR="docs"

inherit distutils-r1 docs

DESCRIPTION="A python module to manipulate default parameters of a module's functions"
HOMEPAGE="https://github.com/bmcfee/presets"
SRC_URI="
	https://github.com/bmcfee/presets/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's:--cov[a-z-]*\(=\| \)[^ ]*.::g' setup.cfg || die
	distutils-r1_src_prepare
}
