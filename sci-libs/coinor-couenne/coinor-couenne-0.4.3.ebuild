# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils multilib

MYPN=Couenne

DESCRIPTION="COIN-OR Convex Over and Under ENvelopes for Nonlinear Estimation"
HOMEPAGE="https://projects.coin-or.org/Couenne/"
SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs test"

RDEPEND="sci-libs/coinor-bonmin"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MYPN}-${PV}/${MYPN}"

src_prepare() {
	# as-needed fix
	# hack to avoid eautoreconf (coinor has its own weird autotools)
	sed -i \
		-e 's:\(libBonCouenne_la_LIBADD.*=\).*:\1 $(top_builddir)/src/libCouenne.la:' \
		src/main/Makefile.in || die

	sed -i \
		-e '/LINK/s/$(libCouenne_la_LIBADD)/@COUENNELIB_LIBS@ $(libCouenne_la_LIBADD)/' \
		src/Makefile.in || die

	# missing includes from Bonmin
	ln -s ../../../Bonmin/src/Interfaces/BonExitCodes.hpp \
		src/main/BonExitCodes.hpp
	ln -s ../../../Bonmin/src/Algorithms/QuadCuts/BonLinearCutsGenerator.hpp \
		src/main/BonLinearCutsGenerator.hpp
}

src_configure() {
	PKG_CONFIG_PATH+="${ED}"/usr/$(get_libdir)/pkgconfig \
		autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	# resolve as-needed
	# circular dependencies between libCouenne and libBonCouenne :(
	pushd ${BUILD_DIR}/src > /dev/null
	rm libCouenne.la main/libBonCouenne.la || die
	emake LIBS+="-Lmain/.libs -lBonCouenne" libCouenne.la
	emake -C main
	popd > /dev/null
}

src_install() {
	autotools-utils_src_install
	use doc && dodoc doc/couenne-user-manual.pdf
	# already installed
	rm "${ED}"/usr/share/coin/doc/${MYPN}/{README,AUTHORS,LICENSE} || die
}
