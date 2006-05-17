# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Documentation reference and man pages for blas implementations"
HOMEPAGE="http://www.netlib.org/blas"
SRC_URI="http://www.netlib.org/lapack/manpages.tgz
http://www.netlib.org/blas/blasqr.ps
http://www.netlib.org/blas/blast-forum/blas-report.ps"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}

src_install() {
	# rename because doman do not yet understand manl files
	rename .l .n blas/man/manl/* man/manl/{lsame,xerbla}.l
	doman blas/man/manl/* \
		man/manl/{lsame,xerbla}.* || die "doman failed"
	dodoc README "${DISTDIR}"/blas{-report,qr}.ps || die "dodoc failed"
}
