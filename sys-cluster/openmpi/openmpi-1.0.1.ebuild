# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib flag-o-matic toolchain-funcs fortran

IUSE="pbs fortran threads static"

MY_P=${P/-mpi}
S=${WORKDIR}/${MY_P}

DESCRIPTION="A High Performance Message Passing Library"
SRC_URI="http://www.open-mpi.org/software/ompi/v1.0/downloads/${MY_P}.tar.bz2"
HOMEPAGE="http://www.open-mpi.org"
PROVIDE="virtual/mpi"
DEPEND="virtual/libc
		pbs? ( virtual/pbs )"

SLOT="6"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD"

FORTRAN="gfortran g77"

src_compile() {

	OMPISLOT=${PV}-"gcc-$(gcc-version)"

	einfo
	einfo "OpenMPI has an overwhelming count of configuration options."
	einfo "Don't forget the EXTRA_ECONF environment variable can let you"
	einfo "specify configure options."
	einfo "${A} will be installed in /usr/$(get_libdir)/${PN}/${OMPISLOT}"
	einfo

	local myconf="--prefix=/usr/$(get_libdir)/${PN}/${OMPISLOT}"
	myconf="${myconf} --datadir=/usr/share/${PN}/${OMPISLOT}"
	myconf="${myconf} --program-suffix=-${OMPISLOT}"
	myconf="${myconf} --sysconfdir=/etc/${PN}/${OMPISLOT}"
	myconf="${myconf} --enable-pretty-print-stacktrace"

	if use threads; then		
		myconf="${myconf} --enable-mpi-threads"
		myconf="${myconf} --with-progress-threads"
		myconf="${myconf} --with-threads=posix"
	fi

	if use fortran; then
		myconf="${myconf} $(use enable fortran mpi-f77)"
		[ "${FORTRANC}" = "g77" ] && \
			myconf="${myconf} --disable-mpi-f90" || \
			myconf="${myconf} --enable-mpi-f90"
	fi
	
	if use static; then
		myconf="${myconf} --enable-static"
		myconf="${myconf} --disable-shared"
		myconf="${myconf} --without-memory-manager"
	fi
	
	use pbs && myconf="${myconf} $(use_with pbs tm /usr/$(get_libdir)/pbs)"
	append-ldflags -Wl,-z,-noexecstack

	econf ${myconf} || die "econf failed"
	emake  || die "emake failed"
}

src_install () {

	make DESTDIR="${D}" install || die "make install failed"

	# fix broken links
	for c in ${D}/usr/$(get_libdir)/${PN}/${OMPISLOT}/bin/*${OMPISLOT}; do
		p=${c/${D}/}
		dosym ${p} ${p/-${OMPISLOT}/}
	done
	
	dodoc README AUTHORS NEWS VERSION
}
