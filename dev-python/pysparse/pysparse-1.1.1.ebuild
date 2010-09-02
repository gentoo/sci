# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils eutils

DESCRIPTION="Sparse linear algebra extension for Python"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://pysparse.sourceforge.net/"

IUSE="doc examples"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD"

RDEPEND="
	dev-python/numpy
	sci-libs/superlu
	<=sci-libs/umfpack-5.4.0"
DEPEND="${DEPEND}"

RESTRICT_PYTHON_ABIS="3.*"

src_prepare() {
	epatch "${FILESDIR}"/${P}-setup.patch
	epatch "${FILESDIR}"/${P}-superlu3.patch
}

src_test() {
	testing() {
		for t in Test/test{Umfpack,Superlu}.py; do
			PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib.*)" "$(PYTHON)" ${t}
		done
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins Doc/*.pdf || die
	fi
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins Examples/* || die
	fi
}
