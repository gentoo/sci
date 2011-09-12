# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools-utils eutils flag-o-matic fortran-2

DESCRIPTION="Parallel 3d FFT"
HOMEPAGE="http://www-user.tu-chemnitz.de/~mpip/software.php"
SRC_URI="http://www-user.tu-chemnitz.de/~mpip/software/${P//_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="static-libs test"

RDEPEND="
	=sci-libs/fftw-3.3*[mpi,fortran]
	virtual/mpi
	"

DEPEND="
	${RDEPEND}
	test? ( virtual/fortran )
	"

S="${WORKDIR}/${P//_}"

src_prepare() {
	local i
	use test && fortran-2_pkg_setup
	for i in Makefile.am configure.ac libpfft.pc.in; do
		cp "${FILESDIR}"/"${PF//_}"-"${i}" "${i}" || die
	done

	append-cppflags "-I${EROOT}/usr/include"

	eautoreconf
}
