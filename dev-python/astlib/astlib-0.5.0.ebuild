# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils eutils

MYPN=astLib
MYP="${MYPN}-${PV}"

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

RESTRICT_PYTHON_ABIS="3.*"

S=${WORKDIR}/${MYP}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.4.0-wcstools.patch
}

src_install() {
	distutils_src_install
	if use doc; then
		dohtml docs/${MYPN}/* || die
	fi
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples || die
	fi
}
