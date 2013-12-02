# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils multilib

MYPN=OS

DESCRIPTION="COIN-OR Optimization Services"
HOMEPAGE="https://projects.coin-or.org/OS/"
SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs test"

RDEPEND="
	sci-libs/coinor-bcp
	sci-libs/coinor-bonmin
	sci-libs/coinor-couenne
	sci-libs/coinor-clp
	sci-libs/coinor-dylp
	sci-libs/coinor-symphony
	sci-libs/coinor-utils
	sci-libs/coinor-vol
	sci-libs/ipopt"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )
	test? ( sci-libs/coinor-sample )"

# fail because coinor-bonmin, couenne, needs hsl library (annoying registration)
RESTRICT=test

S="${WORKDIR}/${MYPN}-${PV}/${MYPN}"

src_prepare() {
	# as-needed fix
	# hack to avoid eautoreconf (coinor has its own weird autotools)
	sed -i \
		-e 's:\(libOS_la_LIBADD.*=\):\1 @OSLIB_LIBS@:g' \
		src/Makefile.in || die
	# bug for later versions of subversions
	sed -i \
		-e 's/xexported/xexported -a "x$svn_rev_tmp" != "xUnversioned directory"/' \
		configure || die
}

src_configure() {
	# autodetect everyting with pkg-config
	# TOFIX: should we do use flags?
	local myeconfargs=()
	PKG_CONFIG_PATH+="${ED}"/usr/$(get_libdir)/pkgconfig \
		autotools-utils_src_configure
}

src_test() {
	pushd "${BUILD_DIR}" > /dev/null || die
	emake test
	popd > /dev/null || die
}

src_install() {
	autotools-utils_src_install
	use doc && dodoc doc/*.pdf
}
