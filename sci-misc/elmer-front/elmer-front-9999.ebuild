# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools eutils subversion

ELMER_ROOT="elmerfem"
MY_PN=${PN/elmer-/}

DESCRIPTION="Elmer is a collection of finite element programs, libraries, and visualization tools, elmer frontend"
HOMEPAGE="http://www.csc.fi/english/pages/elmer"
#SRC_URI="http://elmerfem.svn.sourceforge.net/viewvc/${ELMER_ROOT}/release/${PV}/${MY_PN}/?view=tar -> ${P}.tar.gz"
SRC_URI=""
RESTRICT="mirror"
ESVN_REPO_URI="https://elmerfem.svn.sourceforge.net/svnroot/elmerfem/trunk/${MY_PN}"
ESVN_PROJECT="${MY_PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="X debug"
DEPEND="dev-lang/tcl
	dev-lang/tk
	sci-libs/matc
	sci-libs/elmer-eio
	virtual/opengl"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PV}/front"

src_prepare() {
	#unpack ${A}
	cd "${S}"
	# configure must be executable
	#chmod +x configure
	epatch ${FILESDIR}/elmer-front-Makefile-install.patch
	eautoreconf
}

src_configure() {
	cd "${S}"
	local myconf
	export FC="gfortran"
	export F77="gfortran"
	myconf="${myconf} --with-eioc --with-matc --with-tcltk"
	use debug &&
		myconf="${myconf} --with-debug" ||
		myconf="${myconf} --without-debug"
	econf $myconf \
		$(use_with X x) \
		|| die "econf failed"
}
