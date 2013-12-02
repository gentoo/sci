# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils multilib flag-o-matic

MYPN=Cbc

DESCRIPTION="COIN-OR Branch-and-Cut Mixed Integer Programming Solver"
HOMEPAGE="https://projects.coin-or.org/Cbc/"
SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs test"

RDEPEND="
	sci-libs/coinor-clp
	sci-libs/coinor-cgl
	sci-libs/coinor-dylp
	sci-libs/coinor-osi
	sci-libs/coinor-utils
	sci-libs/coinor-vol"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )
	test? ( sci-libs/coinor-sample )"

S="${WORKDIR}/${MYPN}-${PV}/${MYPN}"

src_prepare() {
	# as-needed fix
	# hack to avoid eautoreconf (coinor has its own weird autotools)
	sed -i \
		-e 's:\(libOsiCbc_la_LIBADD.*=\).*:\1 $(top_builddir)/src/libCbc.la $(top_builddir)/src/libCbcSolver.la:g' \
		src/OsiCbc/Makefile.in || die
	sed -i \
		-e 's:\(libCbc_la_LIBADD.*=.*\)$:\1 @CBCLIB_LIBS@:' \
		-e 's:\(libCbcSolver_la_LIBADD.*=.*\)$:\1 libCbc.la:' \
		-e 's:\(libCbcSolver_la_DEPENDENCIES.*=\).*:\1 libCbc.la:' \
		src/Makefile.in || die
	# bug for later versions of subversions
	sed -i \
		-e 's/xexported/xexported -a "x$svn_rev_tmp" != "xUnversioned directory"/' \
		configure
}

src_configure() {
	local myeconfargs=(
		$(use_with doc dot)
	)
	PKG_CONFIG_PATH+="${ED}"/usr/$(get_libdir)/pkgconfig \
		autotools-utils_src_configure
}

src_compile() {
	# hack for parallel build, to overcome not patching Makefile.am above
	autotools-utils_src_compile -C src libCbc.la
	autotools-utils_src_compile -C src libCbcSolver.la
	autotools-utils_src_compile all $(use doc && echo doxydoc)
}

src_test() {
	pushd "${BUILD_DIR}" > /dev/null || die
	emake test
	popd > /dev/null || die
}

src_install() {
	use doc && HTML_DOC=("${BUILD_DIR}/doxydocs/html/")
	# hack for parallel install, to overcome not patching Makefile.am above
	autotools-utils_src_install -C src install-am
	autotools-utils_src_install
	# already installed
	rm "${ED}"/usr/share/coin/doc/${MYPN}/{README,AUTHORS,LICENSE} || die
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
