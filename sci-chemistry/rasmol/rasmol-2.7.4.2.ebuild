# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit toolchain-funcs eutils

MY_P="RasMol_${PV}"

DESCRIPTION="Free program that displays molecular structure."
HOMEPAGE="http://www.openrasmol.org/"
SRC_URI="http://www.rasmol.org/software/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

RDEPEND="x11-libs/libXext
	x11-libs/libXi
	sci-libs/cbflib
	gtk? ( x11-libs/gtk+:2
		x11-libs/vte )"
DEPEND="${RDEPEND}
	x11-proto/inputproto
	x11-proto/xextproto
	app-text/rman
	x11-misc/imake"

S="${WORKDIR}/${MY_P}_10Apr08"

src_unpack() {
	unpack ${A}
	cd "${S}"

	## We have it in ${DEPEND}.
	## The makefile wants to download it and build it.
	epatch "${FILESDIR}"/cbflib.patch
}

src_compile() {

	cd src

	use gtk && myconf="${myconf} -DGTKWIN"

	xmkmf ${myconf}|| die "xmkmf failed with ${myconf}"
	make clean
	emake DEPTHDEF=-DTHIRTYTWOBIT CC="$(tc-getCC)" \
	CDEBUGFLAGS="${CFLAGS}" \
	|| die "32-bit make failed"
}

src_install () {
	libdir=$(get_libdir)
	insinto /usr/${libdir}/${PN}
	doins doc/rasmol.hlp || die
	dobin src/rasmol || die
	dodoc INSTALL PROJECTS *txt doc/*.{ps,pdf}.gz doc/rasmol.txt.gz
	doman doc/rasmol.1
	insinto /usr/${libdir}/${PN}/databases
	doins data/*

	cat <<- EOF >> "${T}"/envd
	RASMOLPATH="/usr/${libdir}/rasmol"
	RASMOLPDBPATH="/usr/${libdir}/rasmol/databases"
	EOF

	newenvd "${T}"/envd 80rasmol
	dohtml *html html_graphics
}
