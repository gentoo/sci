# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils fortran-2

DESCRIPTION="CCP4 ccif lib"
HOMEPAGE="http://www.ccp4.ac.uk/"
SRC_URI="ftp://ftp.ccp4.ac.uk/opensource/${P}.tar.bz2"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="LGPL-3"
IUSE="+ccp4 static-libs"

RDEPEND="
	ccp4? ( sci-libs/libccp4[fortran] )"
DEPEND="${RDEPEND}"

src_configure() {
	local myeconfargs=( $(use_with ccp4) )
	autotools-utils_src_configure
}
