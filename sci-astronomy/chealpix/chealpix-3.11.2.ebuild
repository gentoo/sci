# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils

MYP="Healpix_3.11"

DESCRIPTION="Hierarchical Equal Area isoLatitude Pixelization of a sphere - C Library"
HOMEPAGE="http://healpix.sourceforge.net/"
SRC_URI="mirror://sourceforge/healpix/${MYP}/autotools_packages/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="static-libs"

RDEPEND="
	>=sci-libs/cfitsio-3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
