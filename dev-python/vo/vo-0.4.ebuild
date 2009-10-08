# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils distutils

DESCRIPTION="Python module to read VOTABLE into a Numpy recarray"
HOMEPAGE="https://www.stsci.edu/trac/ssb/astrolib/"
SRC_URI="http://stsdas.stsci.edu/astrolib/${P}.tar.gz"

DEPEND="doc? ( >=dev-python/sphinx-0.6 )"
RDEPEND=""

IUSE="doc"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="AURA"
# buggy test
RESTRICT=test

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.3.1-docs.patch
}

src_compile() {
	distutils_src_compile
	if use doc; then
		cd doc
		PYTHONPATH=$(dir -d ../build/lib*) emake html pdf || die
	fi
}

src_test() {
	cd test
	PYTHONPATH=$(dir -d ../build/lib*) "${python}" test.py || die
}

src_install() {
	distutils_src_install
	if use doc; then
		cd doc/build
		insinto /usr/share/doc/${PF}
		doins -r html latex/*.pdf || die
	fi
}
