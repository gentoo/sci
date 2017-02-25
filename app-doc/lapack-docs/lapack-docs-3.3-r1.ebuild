# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Documentation reference and man pages for LAPACK implementations"
HOMEPAGE="http://www.netlib.org/lapack/"
SRC_URI="
	http://dev.gentoo.org/~bicatali/lapack-man-${PV}.tar.gz
	http://www.netlib.org/lapack/lapackqref.ps"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}/manpages"

src_install() {
	# These belong to the blas-docs
	rm -f man/manl/{csrot,lsame,xerbla,xerbla_array,zdrot}.* || die

	# rename because doman do not yet understand manl files
	# Not all systems have the rename command, like say FreeBSD
	local f t
	for f in man/manl/*.l; do
		t="${f%%.l}.n"
		mv "${f}" "${t}" || die
	done
	doman man/manl/*
	dodoc README "${DISTDIR}"/lapackqref.ps
}
