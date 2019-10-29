# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit wxwidgets

DESCRIPTION="CTF estimation (ctffind, ctftilt)"
HOMEPAGE="http://grigoriefflab.janelia.org/ctf"
SRC_URI="http://grigoriefflab.janelia.org/sites/default/files/${P}.tar.gz"

LICENSE="Janelia-1.2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	sci-libs/fftw:3.0
	virtual/jpeg
	media-libs/tiff
	x11-libs/wxGTK:3.0
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
