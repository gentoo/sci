# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="The Berkeley UPC-to-C translator"
HOMEPAGE="http://upc.lbl.gov/"
SRC_URI="http://upc.lbl.gov/download/release/${P}.tar.gz"
LICENSE="BSD-4"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-shells/tcsh"

src_prepare() {
	epatch "${FILESDIR}"/${P}-stackoverflow.patch
}

src_compile() {
	emake -j1
}

src_install() {
	emake install PREFIX="${D}/usr/libexec/${P}"
}
