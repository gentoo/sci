# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools eutils subversion

ELMER_ROOT="elmerfem"
MY_PN=${PN/elmer-/}

DESCRIPTION="Elmer is a collection of finite element programs, libraries, and visualization tools, math C lib"
HOMEPAGE="http://www.csc.fi/english/pages/elmer"
#SRC_URI="http://elmerfem.svn.sourceforge.net/viewvc/${ELMER_ROOT}/release/${PV}/${MY_PN}/?view=tar -> ${P}.tar.gz
#doc? ( http://www.nic.funet.fi/pub/sci/physics/elmer/doc/MATCManual.pdf )"
SRC_URI="doc? ( http://www.nic.funet.fi/pub/sci/physics/elmer/doc/MATCManual.pdf )"
RESTRICT="mirror"
ESVN_REPO_URI="https://elmerfem.svn.sourceforge.net/svnroot/elmerfem/trunk/${MY_PN}"
ESVN_PROJECT="${MY_PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc debug"
DEPEND="sys-libs/ncurses
	sys-libs/readline
	sys-libs/glibc"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PV}/matc"

src_prepare() {
	#unpack ${ELMER_ROOT}/${PV}.tar.gz
	#unpack ${PV}.tar.gz
	cd "${S}"
	# we have to make configure executable. SVN snapshot...
	#chmod +x configure
	eautoreconf
}

src_configure() {
	cd "${S}"
	local myconf
	export FC="gfortran"
	export F77="gfortran"
	use debug &&
		myconf="${myconf} --with-debug" ||
		myconf="${myconf} --without-debug"
	econf $myconf || die "econf failed"
}


src_install() {
	insinto /usr/share/doc/${PF}
	use doc && doins ${DISTDIR}/MATCManual.pdf
	emake DESTDIR="${D}" install || die "emake install failed"
}
