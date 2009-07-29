# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/netcdf/netcdf-3.6.3.ebuild,v 1.3 2009/02/17 15:55:14 bicatali Exp $

EAPI=2

inherit fortran eutils toolchain-funcs flag-o-matic autotools

DESCRIPTION="Scientific library and interface for array oriented data access"
SRC_URI="ftp://ftp.unidata.ucar.edu/pub/netcdf/${P}.tar.gz"
HOMEPAGE="http://www.unidata.ucar.edu/software/netcdf/"

LICENSE="UCAR-Unidata"
SLOT="0"
IUSE="fortran debug doc"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
DEPEND="${RDEPEND}
	>=sys-devel/libtool-2.2
	doc? ( virtual/latex-base )"

pkg_setup() {
	if use fortran ; then
		FORTRAN="gfortran ifc g77 pgf77 pgf90"
		fortran_pkg_setup
	fi
}

src_prepare() {
	#epatch "${FILESDIR}"/${P}-as-needed.patch
	#epatch "${FILESDIR}"/${P}-libtool.patch
	eautoreconf
}

src_configure() {
	use debug || append-cppflags -DNDEBUG
	local myconf
	if use fortran; then
		case "${FORTRANC}" in
			g77)
				myconf="${myconf} --enable-f77 --disable-f90"
				myconf="${myconf} F77=g77"
				;;
			pgf77)
				myconf="${myconf} --enable-f77 --disable-f90"
				myconf="${myconf} F77=pgf77"
				;;
			pgf90)
				myconf="${myconf} --enable-f77 --enable-f90"
				myconf="${myconf} FC=pgf90 F90=pgf90 F77=pgf90"
				;;
			ifc|ifort)
				myconf="${myconf} --enable-f77 --enable-f90"
				myconf="${myconf} FC=ifort F90=ifort F77=ifort"
				;;
			*)
				myconf="${myconf} --enable-f77 --enable-f90"
				myconf="${myconf} FC=gfortran F90=gfortran F77=gfortran"
				export F90FLAGS="-i4  ${F90FLAGS}"
				;;
		esac
		# fortran 90 uses FCFLAGS
		export FCFLAGS="${FFLAGS:--O2}"
	else
		myconf="${myconf} --disable-f77 --disable-f90"
	fi
	econf \
		--enable-shared \
		--docdir=/usr/share/doc/${PF} \
		$(use_enable debug flag-setting ) \
		$(use_enable doc docs-install) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc README RELEASE_NOTES VERSION || die "dodoc failed"
	# keep only pdf,txt and html docs, info were already installed
	if use doc; then
		find "${D}usr/share/doc/${PF}" -name \*.ps -exec rm -f {} \;
		find "${D}usr/share/doc/${PF}" -name \*.info -exec rm -f {} \;
		find "${D}usr/share/doc/${PF}" -name \*.txt -exec ecompress {} \;
	fi
}
