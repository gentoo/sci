# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils fortran-2

DESCRIPTION="The Coordinate Library, designed to assist CCP4 developers in working with coordinate files"
HOMEPAGE="http://www.ccp4.ac.uk/"
SRC_URI="ftp://ftp.ccp4.ac.uk/opensource/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="LGPL-3"
IUSE="static-libs"

RDEPEND="virtual/fortran"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-pkg-config.patch
	)
