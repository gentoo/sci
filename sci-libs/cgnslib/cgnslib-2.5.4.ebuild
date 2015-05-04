# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils fortran-2 toolchain-funcs versionator

MY_P="${PN}_$(replace_version_separator 2 '-')"
MY_S="${PN}_$(get_version_component_range 1-2)"

DESCRIPTION="The CFD General Notation System (CGNS) is a standard for CFD data"
HOMEPAGE="http://www.cgns.org/"
SRC_URI="mirror://sourceforge/cgns/${MY_P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fortran hdf5 szip zlib"

DEPEND="
	fortran? ( virtual/fortran )
	hdf5? ( >=sci-libs/hdf5-1.8 )
	szip? ( sci-libs/szip )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_S}

pkg_setup() {
	use fortran && fortran-2_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}.patch
	use hdf5 && epatch "${FILESDIR}"/${P}_hdf5.patch
}

src_configure() {
	local myconf="--enable-gcc --enable-lfs --enable-shared=all --enable-64bit"

	tc-export CC FC

	econf \
		${myconf} \
		$(use_with fortran) \
		$(use_with hdf5) \
		$(use_with zlib) \
		$(use_with szip)
}

src_install() {
	emake DESTDIR="${D}" install
	use hdf5 && \
		fperms 755 /usr/bin/{hdf2adf,adf2hdf} || \
		rm -f "${D}"/usr/bin/{hdf2adf,adf2hdf}
}
