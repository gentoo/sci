# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

AUTOTOOLS_AUTORECONF=true
FORTRAN_NEEDED=fortran
FORTRAN_STANDARD=2003
PYTHON_COMPAT=( python3_{7,8,9} ) # python 3 supported by github master
LUA_COMPAT=( lua5-{1..3} )
USE_RUBY="ruby27 ruby30"

inherit python-single-r1 lua-single ruby-single java-pkg-opt-2 fortran-2

DESCRIPTION="X-ray matter interaction cross sections for X-ray fluorescence library"
HOMEPAGE="https://github.com/tschoonj/xraylib"
SRC_URI="http://lvserver.ugent.be/xraylib/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

#IUSE="examples fortran java lua perl python"
# jave now uses the gradle build system which is not supported by portage
IUSE="examples fortran lua perl php python ruby"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	lua? ( ${LUA_REQUIRED_USE} )
"

RDEPEND="
	lua? ( ${LUA_DEPS} )
	perl? ( dev-lang/perl )
	php? ( <dev-lang/php-8:* )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep \
			'dev-python/numpy[${PYTHON_USEDEP}]'
		)
	)
	ruby? ( ${RUBY_DEPS} )
" # java? ( >=virtual/jre-1.7:* )

DEPEND="${RDEPEND}"
# java? ( >=virtual/jdk-1.7:* )

DOCS=( AUTHORS Changelog README TODO )

pkg_setup() {
	fortran-2_pkg_setup
	java-pkg-opt-2_pkg_setup
	use python && python-single-r1_pkg_setup
}

src_configure() {
	econf \
		--disable-idl \
		$(use_enable fortran fortran2003) \
		$(use_enable lua) \
		$(use_enable perl) \
		$(use_enable perl perl-integration) \
		$(use_enable php) \
		$(use_enable php php-integration) \
		$(use_enable python) \
		$(use_enable python python-integration) \
		$(use_enable python python-numpy) \
		$(use_enable ruby) \
		$(use_enable ruby ruby-integration) \
		# $(use_enable java)
}

src_test() {
	# see https://github.com/tschoonj/xraylib/issues/11
	emake -j1 check
}

src_install() {
	default
	use python && python_optimize

	if use examples; then
		docinto /usr/share/doc/${PF}/examples
		dodoc example/*.c example/*.cpp
		use fortran && dodoc example/*.f90
		use lua && dodoc example/*.lua
		use perl && dodoc example/*.pl
		use php && dodoc example/*.php
		use python && dodoc example/*.py
		use ruby && dodoc example/*.rb
		# use java && dodoc example/*.java
		docompress -x /usr/share/doc/${PF}/examples # Don't compress examples
	fi

	# use java && java-pkg_regso /usr/share/xraylib/java/libxraylib.so
}
