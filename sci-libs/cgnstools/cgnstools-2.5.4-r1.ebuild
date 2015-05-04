# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils multilib versionator

MY_P="${PN}-$(replace_all_version_separators '-')"

DESCRIPTION="The CFD General Notation System (CGNS) tools."
HOMEPAGE="http://www.cgns.org/"
SRC_URI="mirror://sourceforge/cgns/${MY_P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="hdf5 tcl tk X"

DEPEND="hdf5? ( sci-libs/cgnslib[hdf5] )
	!hdf5? ( sci-libs/cgnslib[-hdf5] )
	tcl? ( dev-lang/tcl )
	tk? ( dev-lang/tk )"

RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}.patch
	epatch "${FILESDIR}"/${P}_cgns_to_vtk2D.patch
	epatch "${FILESDIR}"/${P}_gcc4.4.patch
	epatch "${FILESDIR}"/${P}_tcltk.patch
}

src_configure() {
	local myconf
	myconf="${myconf} --enable-gcc --enable-64bit --with-cgns=/usr/include --bindir=${D}/usr/bin --datadir=${D}/usr/share/${PN}"
	use hdf5 && myconf="${myconf} --with-adfh=/usr/include/adfh"

	if use tcl ; then
		TCLVER="$(echo 'puts [info tclversion]' | $(type -P tclsh))"
		myconf="${myconf} $(use_with tcl tcl /usr/$(get_libdir)/tcl${TCLVER})"
		sed -i -e "s|TKLIBS = |TKLIBS = -ltcl${TCLVER} |" make.defs.in
	fi

	if use tk ; then
		# no, there's no tkversion, and type -P wish requires running X
		TKVER="$(echo 'puts [info tclversion]' | $(type -P tclsh))"
		myconf="${myconf} $(use_with tk tk /usr/$(get_libdir)/tk${TKVER})"
		sed -i -e "s|TKLIBS = |TKLIBS = -ltk${TKVER} |" make.defs.in
	fi

	econf \
		$(use_with X x) \
		${myconf} \
		|| die "econf failed"

	sed -i -e "s|${D}||" cgconfig
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}
