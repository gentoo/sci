# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="The Berkeley UPC-to-C translator"
HOMEPAGE="http://upc.lbl.gov/"
SRC_URI="http://upc.lbl.gov/download/release/${P}.tar.gz"

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-shells/tcsh"
RDEPEND="dev-lang/berkeley_upc"

PATCHES=( "$FILESDIR"/${P}-check-abi.patch )

src_prepare() {
	default
	MAKEOPTS+=" -j1"
}

src_install() {
	emake install PREFIX="${D}/usr/libexec/${P}"
}
