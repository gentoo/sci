# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic toolchain-funcs fortran

IUSE="crypt pbs fortran threads static"

MY_P=${P/-mpi}
S=${WORKDIR}/${MY_P}

DESCRIPTION="A High Performance Message Passing Library"
SRC_URI="http://www.open-mpi.org/software/ompi/v1.0/downloads/${MY_P}.tar.bz2"
HOMEPAGE="http://www.open-mpi.org"
PROVIDE="virtual/mpi"
DEPEND="virtual/libc
		pbs? ( virtual/pbs )"
# we need ssh if we want to use it instead of rsh
RDEPEND="${DEPEND}
	crypt? ( net-misc/openssh )
	!crypt? ( net-misc/netkit-rsh )"

SLOT="6"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD"

src_compile() {

	COMPILER="gcc-$(gcc-version)"

	einfo
	einfo "OpenMPI has an overwhelming count of configuration options."
	einfo "Don't forget the EXTRA_ECONF environment variable can let you"
	einfo "specify configure options."
	einfo "${A} will be installed in /usr/$(get_libdir)/${PN}/${PV}-${COMPILER}"
	einfo

	local myconf=""
	use crypt   && RSH=ssh || RSH=rsh;	myconf="${myconf} --with-rsh=${RSH}"
	use threads && myconf="${myconf} --with-threads=posix --enable-mpi-threads"
	use pbs     && append-ldflags "-L/usr/$(get_libdir)/pbs"
	use fortran || myconf="${myconf} --disable-mpi-f77 --disable-mpi-f90"
	use static  && myconf="${myconf} --enable-static --disable-shared"

	econf \
		--prefix=/usr/$(get_libdir)/${PN}/${PV}-${COMPILER} \
		--datadir=/usr/share/${PN}/${PV}-${COMPILER} \
		--program-suffix=-${PV}-${COMPILER} \
		--enable-pretty-print-stacktrace \
		--sysconfdir=/etc/${P} \
		${myconf} || die "econf failed"

	emake  || die "emake failed"
}

src_install () {

	make DESTDIR="${D}" install || die "make install failed"
	dodoc README AUTHORS NEWS HISTORY VERSION INSTALL
}
