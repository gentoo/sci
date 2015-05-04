# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils multilib

MYPN=Bonmin

DESCRIPTION="COIN-OR Basic Open-source Nonlinear Mixed INteger programming"
HOMEPAGE="https://projects.coin-or.org/Bonmin/"
SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples glpk static-libs test"

RDEPEND="
	sci-libs/coinor-cbc
	sci-libs/coinor-clp
	sci-libs/ipopt"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( virtual/latex-base )
	test? ( sci-libs/coinor-sample )"

S="${WORKDIR}/${MYPN}-${PV}/${MYPN}"

src_prepare() {
	# as-needed fix
	# hack to avoid eautoreconf (coinor has its own weird autotools
	sed -i \
		-e 's:\(libbonmin_la_LIBADD.*=\):\1 @BONMINLIB_LIBS@ :' \
		-e 's:\(libbonmin_la_DEPENDENCIES.*=\).*:\1 ../Algorithms/libbonalgorithms.la ../Interfaces/libbonmininterfaces.la Heuristics/libbonheuristics.la:' \
		src/CbcBonmin/Makefile.in || die
}

src_configure() {
	local myeconfargs=()
	PKG_CONFIG_PATH+="${ED}"/usr/$(get_libdir)/pkgconfig \
		autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile all $(use doc && echo doc)
}

src_test() {
	pushd "${BUILD_DIR}" > /dev/null || die
	emake test
	popd > /dev/null || die
}

src_install() {
	autotools-utils_src_install
	use doc && dodoc doc/BONMIN_UsersManual.pdf
	# already installed
	rm "${ED}"/usr/share/coin/doc/${MYPN}/{README,AUTHORS,LICENSE} || die
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi
}
