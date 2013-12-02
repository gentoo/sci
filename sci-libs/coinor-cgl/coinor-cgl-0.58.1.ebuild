# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils multilib

MYPN=Cgl

DESCRIPTION="COIN-OR cutting-plane generators library"
HOMEPAGE="https://projects.coin-or.org/Cgl/"
SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs test"

RDEPEND="
	sci-libs/coinor-clp
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
		-e 's:\(libCgl_la_LIBADD.*=.*\)$:\1 @CGLLIB_LIBS@:' \
		-e 's:\(libCgl_la_DEPENDENCIES.*=\).*:\1 $(CGL_SUBLIBS):' \
		src/Makefile.in || die
	# add missing include header (0.58.0)
	sed -i \
		-e 's:\(includecoin_HEADERS.*=.*\)$:\1 Cgl012cut.hpp:' \
		src/CglZeroHalf/Makefile.in || die
}

src_configure() {
	local myeconfargs=(
		$(use_with doc dot)
	)
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
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
