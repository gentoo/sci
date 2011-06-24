# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools eutils

DESCRIPTION="library for nonequispaced discrete Fourier transform"
HOMEPAGE="http://www-user.tu-chemnitz.de/~potts/nfft"
SRC_URI="http://www-user.tu-chemnitz.de/~potts/nfft/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="static-libs"

RDEPEND="sci-libs/fftw:3.0"
DEPEND="${RDEPEND}"

src_prepare() {
	#file for maintainer mode are not in the tarball
	epatch "${FILESDIR}"/"${P}"-remove-maintainer-mode.patch
	epatch "${FILESDIR}"/"${P}"-install.patch
	eautoreconf || die "eautoreconf failed"
}

src_configure() {
	local myconf
	myconf="--enable-shared $(use_enable static-libs static)"

	econf ${myconf} || die "econf failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
}
