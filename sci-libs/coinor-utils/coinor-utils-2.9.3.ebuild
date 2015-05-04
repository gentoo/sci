# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils multilib toolchain-funcs

MYPN=CoinUtils

DESCRIPTION="COIN-OR Matrix, Vector and other utility classes"
HOMEPAGE="https://projects.coin-or.org/CoinUtils/"
SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="bzip2 doc glpk blas lapack static-libs test zlib"

RDEPEND="
	sys-libs/readline
	bzip2? ( app-arch/bzip2 )
	blas? ( virtual/blas )
	glpk? ( sci-mathematics/glpk )
	lapack? ( virtual/lapack )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )
	test? ( sci-libs/coinor-sample )"

S="${WORKDIR}/${MYPN}-${PV}/${MYPN}"

src_prepare() {
	# as-needed fix
	# hack to avoid eautoreconf (coinor has its own weird autotools)
	sed -i \
		-e 's:\(libCoinUtils_la_LIBADD.*=\).*:\1 @COINUTILSLIB_LIBS@:' \
		src/Makefile.in || die
}

src_configure() {
	local myeconfargs=(
		$(use_enable zlib)
		$(use_enable bzip2 bzlib)
		$(use_with doc dot)
	)
	if use blas; then
		myeconfargs+=( --with-blas-lib="$($(tc-getPKG_CONFIG) --libs blas)" )
	else
		myeconfargs+=( --without-blas )
	fi
	if use glpk; then
		myeconfargs+=(
			--with-glpk-incdir="${EPREFIX}"/usr/include
			--with-glpk-lib=-lglpk
		)
	else
		myeconfargs+=( --without-glpk )
	fi
	if use lapack; then
		myeconfargs+=( --with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)" )
	else
		myeconfargs+=( --without-lapack )
	fi
	PKG_CONFIG_PATH+="${ED}"/usr/$(get_libdir)/pkgconfig \
		autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile all $(use doc && echo doxydoc)
}

src_test() {
	pushd "${BUILD_DIR}" > /dev/null || die
	emake test
	popd > /dev/null || die
}

src_install() {
	use doc && HTML_DOC=("${BUILD_DIR}/doxydocs/html/")
	autotools-utils_src_install
	# already installed
	rm "${ED}"/usr/share/coin/doc/${MYPN}/{README,AUTHORS,LICENSE} || die
}
