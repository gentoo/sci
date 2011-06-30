# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-astronomy/scamp/scamp-1.7.0.ebuild,v 1.1 2010/05/03 21:44:04 bicatali Exp $

EAPI=4

inherit autotools eutils

DESCRIPTION="Performs basic maintenance and packaging tasks on FITS files"
HOMEPAGE="http://www.astromatic.net/software/missfits/"
SRC_URI="http://www.astromatic.net/download/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

src_prepare() {
	epatch "${FILESDIR}"/${P}-configure.patch
	eautoreconf
}

src_install () {
	default
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins doc/*.pdf
	fi
}
