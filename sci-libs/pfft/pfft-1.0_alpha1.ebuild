# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils

DESCRIPTION="parallel 3d FFT"
HOMEPAGE="http://www-user.tu-chemnitz.de/~mpip/software.php"
SRC_URI="http://www-user.tu-chemnitz.de/~mpip/software/${P//_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="static-libs"

RDEPEND="=sci-libs/fftw-3.3*[mpi]
	virtual/mpi"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${P//_}"

src_prepare() {
	local i
	for i in Makefile.am configure.ac libpfft.pc.in; do
		cp "${FILESDIR}"/"${PF//_}"-"${i}" "${i}" || die "cp of ${i} failed"
	done

	eautoreconf || die "eautoreconf failed"
}

src_configure() {
	econf --disable-la-files "$(use_enable static-libs static)" || die "econf failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
}
