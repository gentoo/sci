# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit fortran versionator multilib

MY_P="${PN}_$(replace_version_separator 2 '-')"

DESCRIPTION="The CFD General Notation System (CGNS) is a standard for CFD data."
HOMEPAGE="http://www.cgns.org/"
SRC_URI="mirror://sourceforge/cgns/${MY_P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fortran hdf5 szip zlib"

DEPEND="hdf5? ( sci-libs/hdf5 )
	zlib? ( sys-libs/zlib )
	szip? ( sci-libs/szip )"

MY_S="${PN}_$(get_version_component_range 1-2)"
S="${WORKDIR}"/"${MY_S}"

src_compile() {
	if use fortran ; then
		need_fortran gfortran
		sed -i -e "s| g77 | gfortran |" "${S}"/configure
	fi

	sed -i -e "s|-Wl,-rpath,\\\$cgnsdir/\\\\\$(SYSTEM)|-Wl,-soname -Wl,libcgns.so.0|"	\
		-e "s|-Wl,-R,\\\$cgnsdir/\\\\\$(SYSTEM)|-Wl,-soname -Wl,libcgns.so.0|"		\
		"${S}"/configure

	sed -i -e "s|@STRIP@|true|g"	\
		-e "s|LIBS@|LIBS@ \\\$(PTHREAD_LIBS)|g"	\
		"${S}"/make.defs.in

	local myconf="--enable-gcc --enable-lfs --enable-shared --enable-64bit"

	econf \
		${myconf} \
		$(use_with fortran) \
		$(use_with hdf5) \
		$(use_with zlib) \
		$(use_with szip)

	sed -i -e "s|\$(AROUT)\$@|\$(AROUT)\$@.0|" "${S}"/Makefile

	emake || die "emake failed"
}

src_install() {
	if use amd64 ; then
		local machine=`${S}/cgsystem -64`
	else
		local machine=`${S}/cgsystem`
	fi

	dolib "${S}"/"${machine}"/*.so.0 || die "*.so install failed"

	if use hdf5 ; then
		dobin "${S}"/"${machine}"/hdf2adf || die "hdf2adf install failed"
		dobin "${S}"/"${machine}"/adf2hdf || die "adf2hdf install failed"
	fi

	insinto /usr/include
	doins cgnslib.h cgnslib_f.h cgnswin_f.h
	dosym libcgns.so.0 /usr/$(get_libdir)/libcgns.so
}
