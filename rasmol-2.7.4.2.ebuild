# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/rasmol/rasmol-2.7.2.1.1-r1.ebuild,v 1.6 2007/07/22 07:26:04 dberkholz Exp $

EAPI=1

inherit toolchain-funcs

MY_P="RasMol_${PV}"
MY_S_P="${MY_P}_10Apr08"

DESCRIPTION="Free program that displays molecular structure."
HOMEPAGE="http://www.rasmol.org/"
SRC_URI="http://www.rasmol.org/software/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="gtk"

RDEPEND="x11-libs/libXext
	x11-libs/libXi
	sci-libs/cbflib
	gtk? ( x11-libs/gtk+:2 )"
DEPEND="${RDEPEND}
	x11-proto/inputproto
	x11-proto/xextproto
	app-text/rman
	x11-misc/imake"

S="${WORKDIR}/${MY_S_P}"

src_unpack() {
	unpack ${A}
	cd ${S}

	# Hack required for build
	cd src
	ln -s ../doc

	# Patch out CBFLib, do as separate ebuild.
	epatch "${FILESDIR}"/cbflib.patch
}

src_compile() {
	local myconf
	use gtk && myconf="${myconf} -DGTKWIN"

	cd src
	xmkmf ${myconf} || die
	emake clean || die
	emake \
		DEPTHDEF=-DTHIRTYTWOBIT \
		CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}" \
		|| die
}

src_install () {
	local libdir=$(get_libdir)
	insinto /usr/${libdir}/${PN}
	doins doc/rasmol.hlp
	dobin src/rasmol
	dodoc INSTALL PROJECTS README TODO doc/*.{ps,pdf}.gz doc/rasmol.txt.gz
	doman doc/rasmol.1
	insinto /usr/${libdir}/${PN}/databases
	doins data/*

	cat <<- EOF >> "${T}"/envd
	RASMOLPATH="/usr/${libdir}/rasmol"
	RASMOLPDBPATH="/usr/${libdir}/rasmol/databases"
	EOF

	newenvd "${T}"/envd 80rasmol
}
