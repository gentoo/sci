# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/acml/acml-4.1.0-r1.ebuild,v 1.4 2008/12/07 18:28:37 vapier Exp $

EAPI="3"

inherit eutils versionator

MYP=${PN}-$(replace_all_version_separators -)-lin64

DESCRIPTION="AMD replacement of libm for x86_64 architectures"
HOMEPAGE="http://developer.amd.com/cpu/Libraries/LibM/Pages/default.aspx"
SRC_URI="" #bug 405803
LICENSE="amdlibm"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="examples static-libs"
RESTRICT="fetch strip"

S="${WORKDIR}/${MYP}"

src_test() {
	cd examples
	./build_and_run.sh || die
}

src_install() {
	insinto /opt/${MYP}
	doins -r include || die
	insinto /opt/${MYP}/lib
	doins -r lib/dynamic || die
	use static-libs && doins -r lib/static
	dodoc ReleaseNotes
	dodir /opt/include
	dosym ../${MYP}/include/amdlibm.h /opt/include
	dodir /opt/lib
	dosym ../${MYP}/lib/dynamic/libamdlibm.so /opt/lib
	use static-libs && dosym ../${MYP}/lib/static/libamdlibm.a /opt/lib
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples || die
	fi
}
