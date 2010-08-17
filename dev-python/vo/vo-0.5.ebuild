# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

PYTHON_DEPEND="2:2.6"

inherit distutils eutils

DESCRIPTION="Python module to read VOTABLE into a Numpy recarray"
HOMEPAGE="https://trac6.assembla.com/astrolib/wiki http://www.scipy.org/AstroLib"
SRC_URI="http://stsdas.stsci.edu/astrolib/${P}.tar.gz"

IUSE="test"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="AURA"

DEPEND="${RDEPEND}
	test? ( dev-python/nose )"
RDEPEND="dev-libs/expat"

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-docs.patch
	epatch "${FILESDIR}"/${P}-assertion_fix.patch
	epatch "${FILESDIR}"/${P}-expat.patch
	use test && epatch "${FILESDIR}"/${P}-skiptests.patch
}

#FIX ME: docs are no longer built (missing stsci_sphinxext )

src_test() {
	cd test
	PYTHONPATH=$(dir -d ../build/lib.*) nosetests -v || die
}
