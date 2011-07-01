# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

MPI_PKG_USE_ROMIO=1

inherit autotools eutils fortran-2 mpi

DESCRIPTION="General purpose library and file format for storing scientific data"
HOMEPAGE="http://www.hdfgroup.org/HDF5/"
SRC_URI="http://www.hdfgroup.org/ftp/HDF5/current/src/${P}.tar.gz"

LICENSE="NCSA-HDF"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="cxx examples fortran mpi szip threads zlib"

RDEPEND="
	fortran? ( virtual/fortran )
	mpi? ( $(mpi_pkg_deplist) )
	szip? ( >=sci-libs/szip-2.1 )
	zlib? ( sys-libs/zlib )"

DEPEND="${RDEPEND}
	sys-devel/libtool:2
	sys-process/time"

pkg_setup() {
	fortran && fortran-2_pkg_setup
	if use mpi; then
		if use cxx; then
			ewarn "Simultaneous mpi and cxx is not supported by ${PN}"
			ewarn "Will disable cxx interface"
		fi
		export CC=$(mpi_pkg_cc)
		if use fortran; then
			export FC=$(mpi_pkg_fc)
		fi
	fi
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-1.8.3-as-needed.patch \
		"${FILESDIR}"/${PN}-1.8.3-includes.patch \
		"${FILESDIR}"/${PN}-1.8.3-noreturn.patch \
		"${FILESDIR}"/${P}-gnutools.patch \
		"${FILESDIR}"/${P}-scaleoffset.patch

	# respect gentoo examples directory
	sed \
		-e 's:$(docdir)/hdf5:$(DESTDIR)/$(docdir):' \
		-i $(find . -name Makefile.am) || die
	sed \
		-e '/docdir/d' \
		-i config/commence.am || die
	eautoreconf
	# enable shared libs by default for h5cc config utility
	sed -i -e "s/SHLIB:-no/SHLIB:-yes/g" tools/misc/h5cc.in \
		|| die "sed h5cc.in failed"
}

src_configure() {
	# threadsafe incompatible with many options
	local myconf="--disable-threadsafe"
	use threads && ! use fortran && ! use cxx && ! use mpi \
		&& myconf="--enable-threadsafe"

	if use mpi; then
		myconf="${myconf} --disable-cxx"
	else
	# workaround for bug 285148
		if use cxx; then
			myconf="${myconf} $(use_enable cxx) CXX=$(tc-getCXX)"
		fi
		if use fortran; then
			myconf="${myconf} FC=$(tc-getFC)"
		fi
	fi

	mpi_pkg_set_ld_library_path
	econf $(mpi_econf_args) \
		--disable-sharedlib-rpath \
		--enable-production \
		--enable-strict-format-checks \
		--docdir=/usr/share/doc/${PF} \
		--enable-deprecated-symbols \
		--enable-shared \
		$(use_enable fortran) \
		$(use_enable mpi parallel) \
		$(use_with szip szlib) \
		$(use_with threads pthread) \
		$(use_with zlib) \
		${myconf}
}

src_compile() {
	mpi_pkg_set_ld_library_path
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	mpi_dodoc README.txt
	if use examples; then
		emake DESTDIR="${D}" install-examples \
			|| die "emake install examples failed"
	fi
}

src_test() {
	mpi_pkg_set_ld_library_path
	emake check || die
}
