# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils multilib

DESCRIPTION="Dynamic modification of a user's environment via modulefiles"
HOMEPAGE="http://modules.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test X"

RDEPEND="
	dev-lang/tcl:0=
	dev-tcltk/tclx
	X? ( x11-libs/libX11 )"
DEPEND="${RDEPEND}
	test? ( dev-util/dejagnu )"

S="${WORKDIR}/${P%[a-z]}"

DOCS=(ChangeLog README NEWS TODO)

src_prepare() {
	has_version ">=dev-lang/tcl-8.6.0" && \
		epatch "${FILESDIR}"/${P}-errorline.patch
	epatch \
		"${FILESDIR}"/${P}-bindir.patch \
		"${FILESDIR}"/${P}-versioning.patch \
		"${FILESDIR}"/${P}-clear.patch \
		"${FILESDIR}"/${P}-avail.patch
	sed -e "s:@EPREFIX@:${EPREFIX}:g" \
		"${FILESDIR}"/modules.sh.in > modules.sh
}

src_configure() {
	local myeconfargs=(
		--disable-versioning
		--prefix="${EPREFIX}/usr/share"
		--exec-prefix="${EPREFIX}/usr/share/Modules"
		--with-module-path="${EPREFIX}/etc/modulefiles"
		--with-tcl="${EPREFIX}/usr/$(get_libdir)"
		$(use_with X x)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	insinto /etc/profile.d
	doins modules.sh
	exeinto /usr/share/Modules/bin
	doexe "${FILESDIR}"/createmodule.{sh,py}
	dosym /usr/share/Modules/init/csh /etc/profile.d/modules.csh
	dodir /etc/modulesfiles
}
