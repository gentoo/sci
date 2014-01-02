# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=yes
inherit autotools-utils multilib

MYPN=Smi

DESCRIPTION="COIN-OR Stochastic modelling interface"
HOMEPAGE="https://projects.coin-or.org/Smi/"
SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz"

LICENSE="CPL-1.0"
SLOT="0/2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs test"

RDEPEND="
	sci-libs/coinor-cbc
	sci-libs/coinor-cgl
	sci-libs/coinor-clp
	sci-libs/coinor-flopcpp
	sci-libs/coinor-osi
	sci-libs/coinor-utils"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )
	test? ( sci-libs/coinor-sample )"

S="${WORKDIR}/${MYPN}-${PV}/${MYPN}"

src_prepare() {
	# as-needed fix
	# hack to avoid eautoreconf (coinor has its own weird autotools
	sed -i \
		-e 's:\(libSmi_la_LIBADD.*=\).*:\1 @SMI_LIBS@:g' \
		src/Makefile.in || die
}

src_configure() {
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
	pushd "${AUTOTOOLS_BUILD_DIR}" > /dev/null || die
	emake test
	popd > /dev/null || die
}

src_install() {
	use doc && HTML_DOC=("${WORKDIR}/${MYPN}-${PV}/doxydoc/html/")
	autotools-utils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r Examples/*
	fi
}
