# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools-utils eutils fortran-2 multilib toolchain-funcs

DESCRIPTION="PAW atomic data generator"
HOMEPAGE="http://www.wfu.edu/~natalie/papers/pwpaw/man.html"
SRC_URI="
	http://www.wfu.edu/~natalie/papers/pwpaw/${P}.tar.gz
	doc? (
		http://www.wfu.edu/~natalie/papers/pwpaw/atompaw.pdf
		http://www.wfu.edu/~natalie/papers/pwpaw/notes/atompaw/atompawEqns.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc libxc longplot test"

RDEPEND="
	virtual/blas
	virtual/lapack
	libxc? ( >=sci-libs/libxc-2.0.1[fortran] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( README )

FORTRAN_STANDARD=90

src_unpack() {
	unpack ${P}.tar.gz
	if use doc; then
		cp "${DISTDIR}"/atompaw.pdf "${DISTDIR}"/atompawEqns.pdf "${S}"/doc/ || die
	fi
}

src_prepare() {
	use longplot && epatch "${FILESDIR}"/4.0-longplot.patch
}

src_configure() {
	local myeconfargs=(
		$(use_enable libxc)
		--with-linalg-flavor=atlas
		--with-linalg-libs="$($(tc-getPKG_CONFIG) --libs lapack)"
		--with-libxc-incs="-I/usr/include $($(tc-getPKG_CONFIG) --cflags libxc)"
		--with-libxc-libs="$($(tc-getPKG_CONFIG) --libs libxc)"
		FC="$(tc-getFC)" FCFLAGS="${FCFLAGS:- ${FFLAGS:- -O2}}"
		CC="$(tc-getCC)" LDFLAGS="${LDFLAGS:- ${CFLAGS:- -O2}}"
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile -j1
}

src_test() {
	use test && autotools-utils_src_test
}

src_install() {
	autotools-utils_src_install

	use doc && dodoc doc/atompaw.pdf doc/atompawEqns.pdf
}
