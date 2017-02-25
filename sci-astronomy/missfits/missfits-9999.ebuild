# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit subversion

ESVN_REPO_URI="https://astromatic.net/pubsvn/software/${PN}/trunk"
ESVN_OPTIONS="--trust-server-cert-failures=unknown-ca"

SRC_URI=""
KEYWORDS=""

DESCRIPTION="Performs basic maintenance and packaging tasks on FITS files"
HOMEPAGE="http://www.astromatic.net/software/missfits/"

LICENSE="GPL-3"
SLOT="0"
IUSE="doc"

RDEPEND=""
DEPEND="${RDEPEND}"

src_prepare() {
	default
	subversion_src_prepare
}

src_install () {
	default
	use doc && dodoc doc/*
}
