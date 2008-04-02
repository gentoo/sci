# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib

MY_PN="OpenFst"
MY_P="${MY_PN}-beta-${PV/_beta/}"

DESCRIPTION="Finite State Transducer tools by Google et al."
HOMEPAGE="http://www.openfst.org"
SRC_URI="http://128.122.80.210/~openfst/twiki/pub/FST/FstDownload/${MY_P}.tgz"

LICENSE="Apache-2.0"

SLOT="0"

KEYWORDS="~x86"

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}/fst"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e "s/OPT=.*/OPT=${CXXFLAGS}/g" bin/Makefile
}

src_compile() {
	emake all || die "emake failed"
}

src_install() {
	# bin dir has .o and stuff
	# bins have insecure runpath’s
	for f in $(find bin/ -executable ) ; do
		dobin ${f}
	done
	dodir /usr/include/fst
	dodir /usr/include/fst/lib
	insinto /usr/include/fst/lib
	doins lib/fst.h
	dodir /usr/$(get_libdir)
	insinto /usr/$(get_libdir)
	doins lib/libfst.so
	doins bin/libfstmain.so
	cd "${WORKDIR}/${MY_PN}"
	dodoc README
}

src_test() {
	einfo "make test can take a few hours on moderately modern systems"
	make test || die "check failed"
}
