# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils autotools

DESCRIPTION="General purpose library and file format for storing scientific data"
HOMEPAGE="http://www.hdfgroup.org/HDF5/"
SRC_URI="http://www.hdfgroup.org/ftp/HDF5/current/src/${P}.tar.gz"

LICENSE="NCSA-HDF"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~sparc"

IUSE="cxx examples fortran mpi szip threads zlib"

RDEPEND="mpi? ( virtual/mpi[romio] )
	szip? ( >=sci-libs/szip-2.1 )
	zlib? ( sys-libs/zlib )"

DEPEND="${RDEPEND}
	>=sys-devel/libtool-2.2
	sys-process/time"

pkg_setup() {
	if use mpi && use cxx; then
		ewarn "Simultaneous mpi and cxx is not supported by ${PN}"
		ewarn "Will disable cxx interface"
	fi
	if use mpi && use fortran; then
		export FC=mpif90
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-as-needed.patch
	epatch "${FILESDIR}"/${P}-includes.patch
	epatch "${FILESDIR}"/${P}-gnutools.patch
	epatch "${FILESDIR}"/${P}-noreturn.patch
	epatch "${FILESDIR}"/${P}-destdir.patch
	epatch "${FILESDIR}"/${P}-signal.patch

	# gentoo examples directory
	sed -i \
		-e 's:$(docdir)/hdf5:$(docdir):' \
		$(find . -name Makefile.am) || die
	eautoreconf
}

src_configure() {
	# threadsafe incompatible with many options
	local myconf="--disable-threadsafe"
	use threads && ! use fortran && ! use cxx && ! use mpi \
		&& myconf="--enable-threadsafe"

	if use mpi && use cxx; then
		myconf="${myconf} --disable-cxx"
	elif use cxx; then
		myconf="${myconf} --enable-cxx"
	fi

	econf \
		--docdir=/usr/share/doc/${PF} \
		--disable-sharedlib-rpath \
		--enable-production \
		--enable-shared \
		--enable-strict-format-checks \
		--enable-linux-lfs \
		$(use_enable fortran) \
		$(use_enable mpi parallel) \
		$(use_with szip szlib) \
		$(use_with threads pthread) \
		$(use_with zlib) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README.txt
	if use examples; then
		emake DESTDIR="${D}" install-examples \
			|| die "emake install examples failed"
	fi
}

pkg_postinst() {
	elog "This is still an experimental version of hdf5-1.8.x"
	elog "Please report any bugs, suggestions and patches at:"
	elog "https://bugs.gentoo.org/show_bug.cgi?id=233297"
}
