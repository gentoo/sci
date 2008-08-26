# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator multilib

MY_P="${PN}-$(replace_all_version_separators '-')"
MY_LIB_PN="cgnslib_"
MY_LIB_P="${MY_LIB_PN}$(replace_version_separator 2 '-')"
MY_LIB_SHORT_P="${MY_LIB_PN}$(get_version_component_range 1-2 ${PV})"

DESCRIPTION="The CFD General Notation System (CGNS) tools."
HOMEPAGE="http://www.cgns.org/"
SRC_URI="mirror://sourceforge/cgns/${MY_P}.tar.gz
	mirror://sourceforge/cgns/${MY_LIB_P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fortran tcl tk hdf5 szip zlib X"

RDEPEND="sci-libs/cgnslib
	tcl? ( dev-lang/tcl )
	tk? ( dev-lang/tk )"

DEPEND="${RDEPEND}"

S="${WORKDIR}"/"${PN}"

src_compile() {
	sed -i -e "s| g77 | gfortran |" \
	-e 's|-Wl,-rpath,$cgnsdir/\\$(SYSTEM)|-Wl,-soname,libcgns.so|' \
	-e 's|-Wl,-R,$cgnsdir/\\$(SYSTEM)|-Wl,-soname,libcgns.so|' "${WORKDIR}"/"${MY_LIB_SHORT_P}"/configure

	local myconf
	use amd64 && myconf="${myconf} --enable-64bit"
	myconf="${myconf} --enable-gcc"
	myconf_lib="${myconf} --enable-lfs --enable-shared"

	cd "${WORKDIR}/${MY_LIB_SHORT_P}"
	econf \
		$(use_with fortran) \
		$(use_with hdf5) \
		$(use_with zlib) \
		$(use_with szip) \
		${myconf_lib}

	cd "${S}"

	sed -i -e "s|@STRIP@|true|" \
	-e "s|\\\$(EXE_INSTALL_DIR)/cgnswish|\\\$(EXE_INSTALL_DIR)|" "${S}"/make.defs.in

	sed -i -e "s|CGNSLIB=\\\\\\$\\\(CGNSDIR\\\)/lib/\\\\\\$\\\(LIBCGNS\\\)|CGNSLIB=/usr/$(get_libdir)/libcgns.so|" \
	-e "s|CGNSLIB=\\\\\\$\\\(CGNSDIR\\\)/\\\\\\$\\\(LIBCGNS\\\)|CGNSLIB=/usr/$(get_libdir)/libcgns.so|" \
	-e "s|CGNSLIB=\\\$adfhdir/\\\\\\$\\\(SYSTEM\\\)/libcgns.\\\\\\$\\\(A\\\)|CGNSLIB=/usr/$(get_libdir)/libcgns.so|" \
	-e "s|/unix/|/../|" \
	-e "s|BIN_INSTALL_DIR/\\\$SYSTEM|BIN_INSTALL_DIR|" "${S}"/configure

	myconf="${myconf} --with-cgns=${WORKDIR}/${MY_LIB_SHORT_P} --bindir=${D}/usr/bin --datadir=${D}/usr/share/${PN}"

	if use tcl ; then
		TCLVER="$(echo 'puts [info tclversion]' | $(type -P tclsh))"
		myconf="${myconf} $(use_with tcl tcl /usr/$(get_libdir)/tcl${TCLVER})"
	fi

	if use tk ; then
		# no, there's no tkversion, and type -P wish requires running X
		TKVER="$(echo 'puts [info tclversion]' | $(type -P tclsh))"
		myconf="${myconf} $(use_with tk tk /usr/$(get_libdir)/tk${TKVER})"
	fi

	econf \
		$(use_with X x) \
		${myconf} \
		|| die "econf failed"

	emake || die "emake tools failed"
}

src_install() {
	sed -i -e "s|${D}||" "${S}"/cgconfig

	emake DESTDIR="${D}" install || die "install failed"
}
