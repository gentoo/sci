# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils multilib

MYPN=FlopC++

DESCRIPTION="COIN-OR algebraic modelling language for linear optimization"
HOMEPAGE="https://projects.coin-or.org/FlopC++/"
SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs"

RDEPEND="
	sci-libs/coinor-cgl
	sci-libs/coinor-clp
	sci-libs/coinor-osi"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )"

S="${WORKDIR}/${MYPN}-${PV}/FlopCpp"

src_prepare() {
	# as-needed fix
	# hack to avoid eautoreconf (coinor has its own weird autotools)
	sed -i \
		-e 's:\(libFlopCpp_la_LIBADD.*=.*\)$:\1 @FLOPCPP_LIBS@:' \
		src/Makefile.in || die
}

src_configure() {
	local myeconfargs=(
		$(use_with doc dot)
	)
	PKG_CONFIG_PATH+="${ED}"/usr/$(get_libdir)/pkgconfig \
		autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	if use doc; then
		cd "${WORKDIR}/${MYPN}-${PV}/doxydoc" || die
		doxygen doxygen.conf || die
	fi
}

src_test() {
	pushd "${BUILD_DIR}" > /dev/null || die
	emake test
	popd > /dev/null || die
}

src_install() {
	use doc && HTML_DOC=("${WORKDIR}/${MYPN}-${PV}/doxydoc/html/")
	autotools-utils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
