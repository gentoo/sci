# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="A program and library for generating standard and non-standard InChI and InChIKeys"
HOMEPAGE="http://www.iupac.org/inchi/"
SRC_URI="http://www.iupac.org/inchi/download/version${PV}/INCHI-1-API.zip
	doc? ( http://www.iupac.org/inchi/download/version${PV}/INCHI-1-DOC.zip )"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}/${P}-makefile.patch" || die "Failed to apply ${P}-makefile.patch"
}

src_compile() {
	cd "${WORKDIR}/INCHI-1-API/INCHI_API/gcc_so_makefile"
	emake ISLINUX=1 || die "make failed"
	cd "${WORKDIR}/INCHI-1-API/INCHI/gcc/inchi-1"
	emake || die "make failed"
}

src_install() {
	cd "${WORKDIR}/INCHI-1-API/INCHI/gcc/inchi-1"
	dobin inchi-1
	cd "${WORKDIR}/INCHI-1-API/INCHI_API/gcc_so_makefile/result"
	ln -s libinchi.so.1 libinchi.so
	dolib.so libinchi.so.1.03.00 libinchi.so.1 libinchi.so
	insinto /usr/include
	doins ../../inchi_main/inchi_api.h
	cd "${WORKDIR}/INCHI-1-API"
	dodoc readme.txt readme2.txt
	if use doc ; then
		cd "${WORKDIR}/INCHI-1-DOC/"
		docinto doc
		dodoc *.pdf readme.txt
	fi
}
