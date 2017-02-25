# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit subversion

ESVN_REPO_URI="https://astromatic.net/pubsvn/software/${PN}/trunk"
ESVN_OPTIONS="--trust-server-cert-failures=unknown-ca"

SRC_URI=""
KEYWORDS=""

DESCRIPTION="Converts astronomical FITS images to the TIFF format"
HOMEPAGE="http://www.astromatic.net/software/stiff"

LICENSE="GPL-3"
SLOT="0"
IUSE="doc threads"

RDEPEND="
	media-libs/tiff:0=
	virtual/jpeg:0
	sys-libs/zlib:0="
DEPEND="${RDEPEND}"

src_prepare() {
	default
	subversion_src_prepare
}

src_configure() {
	econf $(use_enable threads)
}

src_install () {
	default
	use doc && dodoc doc/*
}
