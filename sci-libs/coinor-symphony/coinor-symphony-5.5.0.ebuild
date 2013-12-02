# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils multilib

MYPN=SYMPHONY

DESCRIPTION="COIN-OR solver for mixed-integer linear programs"
HOMEPAGE="https://projects.coin-or.org/SYMPHONY/"
SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples glpk static-libs test"

RDEPEND="
	sci-libs/coinor-cgl
	sci-libs/coinor-clp
	sci-libs/coinor-dylp
	sci-libs/coinor-osi
	sci-libs/coinor-utils
	sci-libs/coinor-vol
	glpk? ( sci-mathematics/glpk )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( virtual/latex-base )
	test? ( sci-libs/coinor-sample )"

S="${WORKDIR}/${MYPN}-${PV}/${MYPN}"

src_prepare() {
	# as-needed fix
	# hack to avoid eautoreconf (coinor has its own weird autotools
	sed -i \
		-e 's:\(libOsiSym_la_LIBADD.*=\).*:\1 $(top_builddir)/src/libSym.la:' \
		src/OsiSym/Makefile.in || die
	sed -i \
		-e 's:\(libSym_la_LIBADD.*=\).*:\1 @SYMPHONYLIB_LIBS@:g' \
		src/Makefile.in || die
}

src_configure() {
	local myeconfargs=()
	if use glpk; then
		myeconfargs+=(
			--with-glpk-incdir="${EPREFIX}"/usr/include
			--with-glpk-lib=-lglpk )
	else
		myeconfargs+=( --without-glpk )
	fi
	PKG_CONFIG_PATH+="${ED}"/usr/$(get_libdir)/pkgconfig \
		autotools-utils_src_configure
}

src_compile() {
	# hack for parallel build, to overcome not patching Makefile.am above
	autotools-utils_src_compile -C src libSym.la
	autotools-utils_src_compile
	if use doc; then
		pushd Doc /dev/null
		pdflatex Walkthrough && pdflatex Walkthrough
		# does not compile and doc is online
		#pdflatex man && pdflatex man
		popd > /dev/null
	fi
}

src_test() {
	pushd "${BUILD_DIR}" > /dev/null || die
	emake test
	popd > /dev/null || die
}

src_install() {
	# hack for parallel install, to overcome not patching Makefile.am above
	autotools-utils_src_install -C src install-am
	autotools-utils_src_install
	use doc && dodoc Doc/Walkthrough.pdf
	# already installed
	rm "${ED}"/usr/share/coin/doc/${MYPN}/{README,AUTHORS,LICENSE} || die
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r Examples/*
	fi
}
