# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils multilib

MYP=cppad-${PV}

DESCRIPTION="COIN-OR C++ Algorithmic Differentiation"
HOMEPAGE="https://projects.coin-or.org/CppAD/"
SRC_URI="http://www.coin-or.org/download/source/CppAD/${MYP}.gpl.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

RDEPEND="
	sci-libs/adolc
	sci-libs/ipopt"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )"

S="${WORKDIR}/${MYP}"

src_configure() {
	local myeconfargs=( $(use doc Documentation) )
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	if use doc; then
		./build.sh doxygen || die
	fi
}

src_test() {
	pushd "${BUILD_DIR}" > /dev/null || die
	emake check test
	popd > /dev/null || die
}

src_install() {
	use doc && HTML_DOC=( "${BUILD_DIR}"/doxydocs/html/. )
	autotools-utils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r example/*
	fi
}
