# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils multilib

MYPN=Dip

DESCRIPTION="COIN-OR Decomposition in Integer Programming"
HOMEPAGE="https://projects.coin-or.org/Dip/"
SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples static-libs test"

RDEPEND="
	sci-libs/coinor-alps
	sci-libs/coinor-cbc
	sci-libs/coinor-cgl
	sci-libs/coinor-clp"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( sci-libs/coinor-sample )"

S="${WORKDIR}/${MYPN}-${PV}/${MYPN}"

src_prepare() {
	# as-needed fix
	# hack to avoid eautoreconf (coinor has its own weird autotools)
	sed -i \
		-e 's:\(libDecomp_la_LIBADD.*=\).*:\1 @DIPLIB_LIBS@:g' \
		src/Makefile.in || die
	# bug for later versions of subversions
	sed -i \
		-e 's/xexported/xexported -a "x$svn_rev_tmp" != "xUnversioned directory"/' \
		configure
}

src_configure() {
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
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
