# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib

MY_PN="OpenFst"
MY_P="${MY_PN}-beta-${PV/_beta/}"

DESCRIPTION="Finite State Transducer tools by Google et al."
HOMEPAGE="http://www.openfst.org"
SRC_URI="http://cims.nyu.edu/~openfst/twiki/pub/FST/FstDownload/${MY_P}.tgz"

LICENSE="Apache-2.0"

SLOT="0"

KEYWORDS="~amd64"

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/OpenFst/fst"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${P}-gcc-4.3.patch" || die "Patching failed"
	cd "${S}"
	sed -i -e "s/OPT=\(.*\)/OPT=-fPIC ${CXXFLAGS} \1/g" bin/Makefile
		lib/Makefile
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
	doins lib/{fst,arc,compat,properties,register,symbol-table,util}.h
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

