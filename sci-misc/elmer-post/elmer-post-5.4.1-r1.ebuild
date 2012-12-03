# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools eutils flag-o-matic

ELMER_ROOT="elmerfem"
MY_PN=${PN/elmer-/}

DESCRIPTION="Elmer is a collection of finite element programs, libraries, and visualization tools, elmerpost"
HOMEPAGE="http://www.csc.fi/english/pages/elmer"
SRC_URI="http://elmerfem.svn.sourceforge.net/viewvc/${ELMER_ROOT}/release/${PV}/${MY_PN}/?view=tar -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="opengl X debug"
DEPEND="=dev-lang/tcl-8.4*
	=dev-lang/tk-8.4*
	opengl? ( virtual/opengl
		  media-libs/ftgl )
	sci-libs/matc"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PV}/post"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# configure must be executable
	chmod +x configure
	eautoreconf
}

src_compile() {
	cd "${S}"
	local myconf
	export FC="gfortran"
	export F77="gfortran"
	myconf="${myconf} --with-matc"
	use opengl && append-cppflags -I/usr/include/FTGL
	use debug &&
		myconf="${myconf} --with-debug" ||
		myconf="${myconf} --without-debug"
	econf $myconf \
		$(use_with X x) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake ELMER_POST_DATADIR="${D}/usr/share/elmerpost" DESTDIR="${D}" install || die "emake install failed"
}
