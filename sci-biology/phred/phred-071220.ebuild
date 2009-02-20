# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Phred: a base caller for DNA sequencing"
HOMEPAGE="http://phrap.org/phredphrapconsed.html"
SRC_URI="phred-dist-071220.b-acd.tar.gz"

LICENSE="phrap"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}"

RESTRICT="fetch"

pkg_nofetch() {
	einfo "Please visit ${HOMEPAGE} and obtain the file"
	einfo "${SRC_URI}, then place it in ${DISTDIR}"
}

src_compile() {
	sed -i -e '/LXFLAGS= -DX86_GCC_LINUX/ s/^#//' -e 's/CFLAGS=/CFLAGS += /' Makefile
	emake daev || die
	emake || die
}

src_install() {
	dobin phred daev || die
	insinto /usr/share/${PN}
	doins phredpar.dat || die
	echo "PHRED_PARAMETER_FILE=/usr/share/${PN}/phredpar.dat" > 99phred
	doenvd 99phred || die
	newdoc DAEV.DOC DAEV.DOC.txt
	newdoc PHRED.DOC PHRED.DOC.txt
}
