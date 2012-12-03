# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools eutils flag-o-matic subversion

ELMER_ROOT="elmerfem"
MY_PN=${PN/elmer-/}

DESCRIPTION="Elmer is a collection of finite element programs, libraries, and visualization tools, elmerpost"
HOMEPAGE="http://www.csc.fi/english/pages/elmer"
#SRC_URI="http://elmerfem.svn.sourceforge.net/viewvc/${ELMER_ROOT}/release/${PV}/${MY_PN}/?view=tar -> ${P}.tar.gz"
SRC_URI=""
RESTRICT="mirror"
ESVN_REPO_URI="https://elmerfem.svn.sourceforge.net/svnroot/elmerfem/trunk/${MY_PN}"
ESVN_PROJECT="${MY_PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="opengl X debug"
DEPEND="dev-lang/tcl
	dev-lang/tk
	opengl? ( virtual/opengl
		  media-libs/ftgl )
	sci-libs/matc"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PV}/post"

src_prepare() {
	#unpack ${A}
	cd "${S}"
	# configure must be executable
	#chmod +x configure
	eautoreconf
}

src_configure() {
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
}

src_install() {
	emake ELMER_POST_DATADIR="/usr/share/${MY_PN}" DESTDIR="${D}" install || die "emake install failed"
}
