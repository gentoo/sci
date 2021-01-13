# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3{7,8,9} )

DOCS_BUILDER="doxygen"
DOCS_DIR="doc/webgen"
DOCS_DEPEND="media-gfx/graphviz"

inherit docs

COMMIT="a8e49ef56dc8be5256b5305ec6702d50c5b36c09"

DESCRIPTION="C++ Template Unit Test Framework"
HOMEPAGE="https://mrzechonek.github.io/tut-framework/"
SRC_URI="https://github.com/mrzechonek/tut-framework/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="examples"

S="${WORKDIR}/${PN}-framework-${COMMIT}"

BDEPEND="dev-util/waf"

src_configure() {
	waf configure || die "waf configure failed"
}

src_compile() {
	waf build || die "waf compile failed"
	docs_compile
}

src_install() {
	default
	# install function does not work for some reason
	#waf install || die "waf install failed"
	cp -r build/* . || die

	doheader -r include/*

	if use examples ; then
		dodoc -r example
	fi
}
