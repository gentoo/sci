# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils multilib versionator

MY_P="${PN}-$(replace_all_version_separators '-')"

DESCRIPTION="The CFD General Notation System (CGNS) tools"
HOMEPAGE="http://www.cgns.org/"
SRC_URI="mirror://sourceforge/cgns/${MY_P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="hdf5 tcl tk X"

DEPEND="
	hdf5? ( sci-libs/cgnslib[hdf5] )
	!hdf5? ( sci-libs/cgnslib[-hdf5] )
	tcl? ( dev-lang/tcl:0= )
	tk? ( dev-lang/tk:0= )"

RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

PATCHES=(
	"${FILESDIR}"/${P}.patch
	"${FILESDIR}"/${P}_cgns_to_vtk2D.patch
	"${FILESDIR}"/${P}_gcc4.4.patch
	"${FILESDIR}"/${P}_tcltk.patch
)

src_prepare() {
	epatch "${PATCHES[@]}"
}

src_configure() {
	local myconf
	myconf="${myconf} --enable-gcc --enable-64bit --with-cgns=/usr/include --bindir=${D}/usr/bin --datadir=${D}/usr/share/${PN}"
	use hdf5 && myconf="${myconf} --with-adfh=/usr/include/adfh"

	if use tcl ; then
		TCLVER="$(echo 'puts [info tclversion]' | $(type -P tclsh))"
		myconf="${myconf} $(use_with tcl tcl /usr/$(get_libdir)/tcl${TCLVER})"
		sed -i -e "s|TKLIBS = |TKLIBS = -ltcl${TCLVER} |" make.defs.in || die
	fi

	if use tk ; then
		# no, there's no tkversion, and type -P wish requires running X
		TKVER="$(echo 'puts [info tclversion]' | $(type -P tclsh))"
		myconf="${myconf} $(use_with tk tk /usr/$(get_libdir)/tk${TKVER})"
		sed -i -e "s|TKLIBS = |TKLIBS = -ltk${TKVER} |" make.defs.in || die
	fi

	econf \
		$(use_with X x) \
		${myconf}

	sed -i -e "s|${D}||" cgconfig || die
}
