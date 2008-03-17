# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator toolchain-funcs

MY_PV=$(replace_all_version_separators '-')

DESCRIPTION="Cis-eLement OVERrepresentation: Detection of functional DNA motifs"
HOMEPAGE="http://zlab.bu.edu/clover/"
SRC_URI="http://zlab.bu.edu/~mfrith/downloads/${PN}-${MY_PV}.tar.gz http://zlab.bu.edu/clover/jaspar2005core"

LICENSE="as-is"
SLOT="0"
IUSE=""
KEYWORDS="~x86"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}-${MY_PV}"

src_unpack() {
	unpack ${PN}-${MY_PV}.tar.gz
}

src_compile() {
	sed -i "s:g++:$(tc-getCXX):; s:-Wall -O3:${CFLAGS}:" Makefile || die "sed failed"
	emake || die "emake failed"
}

src_install() {
	dobin clover
	dodir "/usr/share/${PN}"
	insinto "/usr/share/${PN}"
	doins ${DISTDIR}/jaspar2005core || die
}

pkg_postinst() {
	einfo "The motif library jaspar2005core has been installed in"
	einfo "    /usr/share/clover/jaspar2005core"
	einfo "You can pass this library to clover for motif search, or use your own library."
}
