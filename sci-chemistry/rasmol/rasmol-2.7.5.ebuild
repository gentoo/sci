# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit toolchain-funcs eutils

MY_P="RasMol_${PV}"
VERS="23Jul09"

DESCRIPTION="Molecular Graphics Visualisation Tool"
HOMEPAGE="http://www.openrasmol.org/"
SRC_URI="http://www.rasmol.org/software/${MY_P}.tar.gz"

LICENSE="|| ( GPL-2 RASLIC )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/gtk+:2
	x11-libs/vte
	>=x11-libs/xforms-1.0.91
	dev-libs/cvector
	sci-libs/cbflib
	sci-libs/neartree
	sci-libs/cqrlib"
DEPEND="${RDEPEND}
	x11-proto/inputproto
	x11-proto/xextproto
	app-text/rman
	x11-misc/imake"

S="${WORKDIR}/${P}-${VERS}"

src_prepare() {
	cd src

	use amd64 && \
		mv rasmol.h rasmol_amd64_save.h && \
		echo "#define _LONGLONG"|cat - rasmol_amd64_save.h > rasmol.h

	mv Imakefile_base Imakefile
	epatch "${FILESDIR}"/${PV}-bundled-lib.patch

	sed "s:EPREFIX:${EPREFIX}:g" -i Imakefile

	xmkmf -DGTKWIN ${myconf}|| die "xmkmf failed with ${myconf}"

	epatch "${FILESDIR}"/ldflags.patch

}

src_compile() {
	cd src
	make clean
	emake \
		DEPTHDEF=-DTHIRTYTWOBIT \
		CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}" \
		|| die "make failed"
}

src_install () {
	libdir=$(get_libdir)
	insinto /usr/${libdir}/${PN}
	doins doc/rasmol.hlp || die
	dobin src/rasmol || die
	dodoc PROJECTS {README,TODO}.txt doc/*.{ps,pdf}.gz doc/rasmol.txt.gz || die
	doman doc/rasmol.1 || die
	insinto /usr/${libdir}/${PN}/databases
	doins data/* || die

#	cat <<- EOF >> "${T}"/envd
#	RASMOLPATH="/usr/${libdir}/rasmol"
#	RASMOLPDBPATH="/usr/${libdir}/rasmol/databases"
#	EOF

#	newenvd "${T}"/envd 80rasmol || die
	dohtml -r *html doc/*.html html_graphics
}
