# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Documentation reference and man pages for blas implementations"
HOMEPAGE="http://www.netlib.org/blas/"
SRC_URI="
	http://dev.gentoo.org/~bicatali/lapack-man-${PV}.tar.gz
	http://www.netlib.org/blas/blasqr.pdf
	http://www.netlib.org/blas/blast-forum/blas-report.pdf"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}/manpages"

src_install() {
	# rename because doman do not yet understand manl files
	# Not all systems have the rename command, like say FreeBSD
	local f t
	for f in blas/man/manl/*.l; do
		t="${f%%.l}.n"
		mv "${f}" "${t}" || die
	done
	doman blas/man/manl/*.n
	dodoc README "${DISTDIR}"/blas{-report,qr}.pdf
}
