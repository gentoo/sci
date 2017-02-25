# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF="1"
inherit eutils autotools-multilib

DESCRIPTION="Libconfig is a simple library for manipulating structured configuration files"
HOMEPAGE="http://www.hyperrealm.com/libconfig/libconfig.html"

LICENSE="LGPL-2.1"
SLOT="0"
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/hyperrealm/libconfig.git git://github.com/hyperrealm/libconfig.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="http://www.hyperrealm.com/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-linux"
	PATCHES=( "${FILESDIR}/${P}-out-of-source-build.patch" )
fi

IUSE="+cxx examples static-libs"

DEPEND="
	sys-devel/libtool
	virtual/yacc"

src_prepare() {
	sed -i configure.ac -e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' || die
	autotools-multilib_src_prepare
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable cxx)
		--disable-examples
	)
	autotools-utils_src_configure
}

multilib_src_test() {
	# It responds to check but that does not work as intended
	emake test
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
