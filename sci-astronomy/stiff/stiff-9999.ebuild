# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-astronomy/stiff/stiff-2.1.3.ebuild,v 1.1 2011/04/10 14:45:35 bicatali Exp $

EAPI=5

if [[ ${PV} == "9999" ]] ; then
	_SVN=subversion
	ESVN_REPO_URI="https://astromatic.net/pubsvn/software/${PN}/trunk"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://www.astromatic.net/download/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

AUTOTOOLS_AUTORECONF=true

inherit ${_SVN} autotools-utils

DESCRIPTION="Converts astronomical FITS images to the TIFF format"
HOMEPAGE="http://astromatic.iap.fr/software/stiff"

LICENSE="GPL-3"
SLOT="0"
IUSE="doc threads"

RDEPEND="
	media-libs/tiff
	virtual/jpeg
	sys-libs/zlib"
DEPEND="${RDEPEND}"

src_configure() {
	local myeconfargs=( $(use_enable threads) )
	autotools-utils_src_configure
}

src_install () {
	use doc && DOCS=( doc/. )
	autotools-utils_src_install
}
