# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils fortran-2 multilib toolchain-funcs

DESCRIPTION="PAW atomic data generator"
HOMEPAGE="http://www.wfu.edu/~natalie/papers/pwpaw/man.html"
SRC_URI="
	http://www.wfu.edu/~natalie/papers/pwpaw/${P}.tar.gz
	doc? (
		http://www.wfu.edu/~natalie/papers/pwpaw/atompaw.pdf
		http://www.wfu.edu/~natalie/papers/pwpaw/atompaw-usersguide.pdf
		http://www.wfu.edu/~natalie/papers/pwpaw/notes/atompaw/atompawEqns.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc libxc"

RDEPEND="
	virtual/lapack
	virtual/blas
	libxc? ( sci-libs/libxc[fortran] )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${P}.tar.gz
	if use doc; then
		cp "${DISTDIR}"/atompaw.pdf "${S}"/
		cp "${DISTDIR}"/atompaw-usersguide.pdf "${S}"/
		cp "${DISTDIR}"/atompawEqns.pdf "${S}"/
	fi
}

src_configure() {
	local modules="-I/usr/$(get_libdir)/finclude"
	econf $(use_enable libxc) \
	--with-linalg-flavor=atlas \
	--with-linalg-libs="$(pkg-config --libs lapack)" \
	--with-libxc-incs="${modules}" \
	--with-libxc-libs="${libs} -lxc" \
	FC="$(tc-getFC)" FCFLAGS="${FCFLAGS:- ${FFLAGS:- -O2}}" \
	CC="$(tc-getCC)" LDFLAGS="${LDFLAGS:- ${CFLAGS:- -O2}}"
}

src_compile() {
	emake -j1 || die "Make failed"
}

src_test() {
	emake check || die "Test failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc README || die "dodoc failed"

	if use doc; then
		dodoc atompaw.pdf atompaw-usersguide.pdf atompawEqns.pdf || die "PDF doc failed"
	fi
}
