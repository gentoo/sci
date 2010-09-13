# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="Normaliz is a tool for computations in affine monoids and more"
HOMEPAGE="http://www.mathematik.uni-osnabrueck.de/normaliz/"
SRC_URI="http://www.mathematik.uni-osnabrueck.de/normaliz/Normaliz${PV}.zip"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc extras optimization"

DEPEND="dev-libs/gmp[-nocxx]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/Normaliz${PV}/source"

src_prepare () {
	if ! use optimization; then
		sed -i "s/-O3 -funroll-loops/${CXXFLAGS}/" Makefile || die "sed on Makefile failed"
	fi
}

src_install() {
	dobin norm64 normbig || die "install failed"
	if use doc; then
		dodoc "../doc/Normaliz${PV}Documentation.pdf" || die "install failed"
	fi
	if use extras; then
		elog "You have selected to install extras which consist of a gui jNormaliz.jar,"
		elog "and Macaulay2 and Singular packages. These have been installed into "
		elog "/usr/share/${PN}, and cannot be used without additional work. Please refer"
		elog "to the homepages of the respective projects for additional information."
		elog "Note however, Gentoo's versions of Singular and Macaulay2 bring their own"
		elog "copies of these interface packages."
		insinto "/usr/share/${PN}"
		doins "../jNormaliz.jar"
		doins "../Singular/normaliz.lib"
		doins "../Macaulay2/Normaliz.m2"
	fi
}