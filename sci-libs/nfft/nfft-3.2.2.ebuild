# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools-utils eutils toolchain-funcs

DESCRIPTION="library for nonequispaced discrete Fourier transform"
HOMEPAGE="http://www-user.tu-chemnitz.de/~potts/nfft"
SRC_URI="http://www-user.tu-chemnitz.de/~potts/nfft/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="openmp static-libs"

RDEPEND="sci-libs/fftw:3.0[openmp?]"
DEPEND="${RDEPEND}"

pkg_pretend() {
	use openmp && ! tc-has-openmp && \
		die "Please switch to an openmp compatible compiler"
}

src_configure() {
	local myeconfargs=(
	    --enable-all
		$(use_enable openmp)
	)
	autotools-utils_src_configure
}
