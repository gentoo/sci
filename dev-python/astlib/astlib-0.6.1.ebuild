# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils

MYPN=astLib
MYP=${MYPN}-${PV}

DESCRIPTION="Python astronomy modules for coordinate conversion and manipulating FITS images"
HOMEPAGE="http://astlib.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MYP}.tar.gz"

IUSE="doc examples"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD"

DEPEND="sci-astronomy/wcstools"
RDEPEND="${DEPEND}
	dev-python/matplotlib
	dev-python/imaging
	dev-python/pyfits
	sci-libs/scipy"

S="${WORKDIR}/${MYP}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.6.0-wcstools.patch
	distutils_src_prepare
}

src_install() {
	distutils_src_install
	use doc && dohtml docs/${MYPN}/*
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
