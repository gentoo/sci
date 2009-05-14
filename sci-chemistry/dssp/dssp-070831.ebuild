# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit toolchain-funcs flag-o-matic

DESCRIPTION="The protein secondary structure standard"
HOMEPAGE="http://swift.cmbi.ru.nl/gv/dssp/"
SRC_URI="ftp://ftp.cmbi.ru.nl/pub/molbio/software/dsspcmbi.tar.gz"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}

src_prepare() {
	cp "${FILESDIR}"/Makefile .
	append-flags -DGCC
}

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_install() {
	dobin dssp || die
	dodoc README.TXT || die
	dohtml index.html || die
}

pkg_postinst() {
	elog "Go to ${HOMEPAGE} and return the license agreement."
	elog "One of its requirements is citing the article:"
	elog "Kabsch, W. & Sander, C. Biopolymers 22:2577-2637 (1983)."
}
