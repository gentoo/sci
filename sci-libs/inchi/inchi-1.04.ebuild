# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/inchi/inchi-1.03.ebuild,v 1.1 2011/03/26 15:18:23 jlec Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="A program and library for generating standard and non-standard InChI and InChIKeys"
HOMEPAGE="http://www.iupac.org/inchi/"
SRC_URI="
	http://www.inchi-trust.org/sites/default/files/inchi-${PV}/INCHI-1-API.ZIP
	doc? ( http://www.inchi-trust.org/sites/default/files/inchi-${PV}/INCHI-1-DOC.ZIP )"

LICENSE="IUPAC+InChI-Trust_InChI_Licence-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"/INCHI-1-API

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.03-shared.patch
}

src_compile() {
	for dir in  INCHI/gcc/inchi-1 INCHI_API/gcc_so_makefile; do
	pushd ${dir} > /dev/null
		emake \
			C_COMPILER=$(tc-getCC) \
			CPP_COMPILER=$(tc-getCXX) \
			LINKER="$(tc-getCXX) ${LDFLAGS}" \
			SHARED_LINK="$(tc-getCC) ${LDFLAGS} -shared" \
			C_COMPILER_OPTIONS="\${P_INCL} -ansi -DCOMPILE_ANSI_ONLY ${CFLAGS} -c " \
			CPP_COMPILER_OPTIONS="\${P_INCL} -D_LIB -ansi ${CXXFLAGS} -frtti -c " \
			C_OPTIONS="${CFLAGS} -fPIC -c " \
			LINKER_OPTIONS="${LDFLAGS}" \
			CREATE_MAIN= \
			ISLINUX=1
		popd
	done
}

src_install() {
	dodoc readme*.txt
	if use doc ; then
		cd "${WORKDIR}/INCHI-1-DOC/"
		docinto doc
		dodoc *.pdf readme.txt
	fi
	cd "${S}/INCHI/gcc/inchi-1"
	dobin inchi-1
	cd "${S}/INCHI_API/gcc_so_makefile/result"
	rm *gz
	dolib.so lib*
	insinto /usr/include
	doins ../../inchi_main/inchi_api.h
}
