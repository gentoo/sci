# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Documentation reference and man pages for ScaLAPACK implementations"
HOMEPAGE="http://www.netlib.org/scalapack/scalapack_home.html"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"

src_install() {
	# rename because doman do not yet understand manl files
	# Not all systems have the rename command, like say FreeBSD
	local f= t=
	for f in MANPAGES/man/manl/*.l; do
		t="${f%%.l}.n"
		mv "${f}" "${t}"
	done
	doman MANPAGES/man/manl/* || die "doman failed"
	dodoc *.ps || die "dodoc failed"
}
