# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=3
inherit autotools eutils flag-o-matic toolchain-funcs

DESCRIPTION="A library of F90 routines to read/write the ETSF file format"
SRC_URI="http://www.etsf.eu/sites/default/files/${P}.tar.gz"
HOMEPAGE="http://www.etsf.eu/resources/software/libraries_and_tools"

LICENSE="LGPL"
SLOT="0"
IUSE="examples"
KEYWORDS="~amd64 ~x86"

RDEPEND="sci-libs/netcdf[fortran]"
DEPEND="${RDEPEND}"

src_unpack() {
	tar xf ${DISTDIR}/${A}
}

src_configure() {
	# fortran 90 uses FCFLAGS
	export FCFLAGS="${FFLAGS:--O2}"
	econf \
		--prefix=/usr \
		$(use_enable examples build-tutorials) \
		--with-netcdf-ldflags="-L/usr/lib -lnetcdff" \
		--with-moduledir=/usr/lib/finclude
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc README NEWS COPYING AUTHORS INSTALL ChangeLog || die "dodoc failed"
}
