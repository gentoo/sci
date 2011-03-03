# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit toolchain-funcs

DESCRIPTION="SSAHA2: Sequence Search and Alignment by Hashing Algorithm"
HOMEPAGE="http://www.sanger.ac.uk/resources/software/ssaha2"
SRC_URI="x86? ( ftp://ftp.sanger.ac.uk/pub4/resources/software/ssaha2/ssaha2_i686.tgz )
		amd64? ( ftp://ftp.sanger.ac.uk/pub4/resources/software/ssaha2/ssaha2_x86_64.tgz )
		ia64? ( ftp://ftp.sanger.ac.uk/pub4/resources/software/ssaha2/ssaha2_ia64.tgz )
		ftp://ftp.sanger.ac.uk/pub4/resources/software/ssaha2/samflag.c
		ftp://ftp.sanger.ac.uk/pub4/resources/software/ssaha2/ssaha2-manual.pdf"

LICENSE="GRL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

if use x86; then
	S="${WORKDIR}"/ssaha2_v"${PV}"_i686
fi
if use amd64; then
	S="${WORKDIR}"/ssaha2_v"${PV}"_x86_64
fi
if use ia64; then
	S="${WORKDIR}"/ssaha2_v"${PV}"_ia64
fi

src_compile() {
	$(tc-getCC) ${CFLAGS} -o samflag "${DISTDIR}"/samflag.c || die "Failed to compile samflags"
}

src_install() {
	dobin samflag ssaha2 ssaha2Build ssahaSNP || die "dobin failed"
	dodoc README || die "dodoc failed"
	dodoc "${DISTDIR}"/ssaha2-manual.pdf || die "Failed to install ssaha2-manual.pdf"
}

