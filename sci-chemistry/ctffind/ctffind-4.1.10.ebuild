# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0-gtk3"
inherit wxwidgets

DESCRIPTION="CTF estimation (ctffind, ctftilt)"
HOMEPAGE="https://grigoriefflab.umassmed.edu/"
SRC_URI="https://grigoriefflab.umassmed.edu/system/tdf?path=ctffind-${PV}.tar.gz&file=1&type=node&id=26 -> ${P}.tar.gz"

LICENSE="Janelia-1.2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	sci-libs/fftw:3.0
	media-libs/libjpeg-turbo
	media-libs/tiff
	x11-libs/wxGTK:*
"
RDEPEND="${DEPEND}"
BDEPEND="
	${DEPEND}
	virtual/pkgconfig"

src_prepare() {
	default
	sed /pdb/d -i src/core/core_headers.h || die "removing pdb.h failed"
	sed /water/d -i src/core/core_headers.h || die "removing water.h failed"
}

src_configure() {
	setup-wxwidgets
	default
}
