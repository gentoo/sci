# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools fortran


DESCRIPTION="Arnoldi Package Library to solve large scale eigenvalue problems."
HOMEPAGE="http://www.caam.rice.edu/software/ARPACK"
# not a very good name: patch.tar.gz :(
SRC_URI="http://www.caam.rice.edu/software/ARPACK/SRC/${PN}${PV}.tar.gz
	http://www.caam.rice.edu/software/ARPACK/SRC/patch.tar.gz
	http://www.caam.rice.edu/software/ARPACK/SRC/p${PN}${PV}.tar.gz
	http://www.caam.rice.edu/software/ARPACK/SRC/ppatch.tar.gz"

LICENSE="BSD"
SLOT="0"

IUSE="blas mpi examples"
KEYWORDS="~amd64 ~x86"
DEPEND="virtual/libc
	blas? ( virtual/blas )
	mpi? ( virtual/mpi )"

S=${WORKDIR}/ARPACK

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${PN}-autotools.patch
	cd "${S}"
	eautoreconf
}

src_compile() {
	econf \
		--includedir=/usr/include/arpack \
		$(use_enable mpi) \
		$(use_with blas) \
		|| "econf failed"
	emake || "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc README
	docinto DOCUMENTS
	dodoc DOCUMENTS/*

	if use examples; then
		insinto /usr/share/doc/${P}
		doins "${FILESDIR}"/ARmake.inc
		doins -r EXAMPLES
		if use mpi; then 
			insinto /usr/share/doc/${P}/PARPACK/EXAMPLES
			doins -r PARPACK/EXAMPLES/MPI
		fi
	fi
}
