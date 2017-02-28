# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils git-r3 multilib-minimal

DESCRIPTION="Libconfig is a simple library for manipulating structured configuration files"
HOMEPAGE="http://www.hyperrealm.com/libconfig/libconfig.html"
EGIT_REPO_URI="https://github.com/hyperrealm/libconfig.git git://github.com/hyperrealm/libconfig.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="+cxx examples static-libs"

DEPEND="
	sys-devel/libtool
	virtual/yacc"

src_prepare() {
	sed -i configure.ac -e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' || die
	multilib-minimal_src_prepare
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable cxx)
		--disable-examples
	)
	econf ${myeconfargs[@]}
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files

	if use examples; then
		find examples/ -name "Makefile.*" -delete || die
		local dir
		for dir in examples/c examples/c++; do
			insinto /usr/share/doc/${PF}/${dir}
			doins ${dir}/*
		done
	fi
}
