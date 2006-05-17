# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="Documentation reference and man pages for lapack implementations"
HOMEPAGE="http://www.netlib.org/lapack"
SRC_URI="http://www.netlib.org/lapack/manpages.tgz
	http://www.netlib.org/lapack/lapackqref.ps"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}

src_compile() {
	$(tc-getCC) -o equivalence equivalence.c || "compiling equivalence failed"
}

src_install() {
	dobin equivalence
	# These belong to the blas-docs
	rm -f man/manl/{lsame,xerbla}.*
	# This one is empty
	rm -f man/manl/zbcon.l
	# rename because doman do not yet understand manl files
	rename .l .n man/manl/*.l
	doman man/manl/* || "doman failed"
	dodoc README "${DISTDIR}"/lapackqref.ps || die "dodoc failed"
}
