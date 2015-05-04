# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils toolchain-funcs versionator

Sing_PV=$(replace_all_version_separators -)
Sing_DIR=$(get_version_component_range 1-3 ${MY_PV})
MY_PV_SHARE=${MY_PV}

DESCRIPTION="omalloc is the memory management of the Singular algebra system"
HOMEPAGE="http://www.singular.uni-kl.de/"
SRC_COM="http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/3-1-1"
SRC_URI="${SRC_COM}/Singular-3-1-1-2.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"

S=${WORKDIR}/Singular-3-1-1/omalloc

# Until tarballs are mirrored:
RESTRICT="mirror"

pkg_setup() {
	tc-export CC CXX
}

src_prepare (){
	epatch "${FILESDIR}"/${P}-gentoo.diff
}

src_configure() {
	econf \
		$(use_with debug)
}

src_test () {
	if use debug; then
		emake check || die
	fi
}

src_install () {
	emake DESTDIR="${D}" install || die
}
