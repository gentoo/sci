# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs versionator

MY_PV=$(replace_all_version_separators '-')

DESCRIPTION="Cis-eLement OVERrepresentation: Detection of functional DNA motifs"
HOMEPAGE="http://zlab.bu.edu/clover/"
SRC_URI="
	http://zlab.bu.edu/~mfrith/downloads/${PN}-${MY_PV}.tar.gz
	http://zlab.bu.edu/clover/jaspar2009core"

LICENSE="freedist"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	sed \
		-e "s:g++:$(tc-getCXX) \$(LDFLAGS):; s:-Wall -O3:${CFLAGS}:" \
		-i Makefile || die "sed failed"
}

src_install() {
	dobin clover
	insinto /usr/share/${PN}
	doins "${DISTDIR}/jaspar2009core"
}

pkg_postinst() {
	einfo "The motif library jaspar2009core has been installed in"
	einfo "    /usr/share/clover/jaspar2009core"
	einfo "You can pass this library to clover for motif search, or use your own library."
}
