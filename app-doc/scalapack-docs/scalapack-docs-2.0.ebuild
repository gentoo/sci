# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Documentation reference and man pages for ScaLAPACK implementations"
HOMEPAGE="http://www.netlib.org/scalapack/"
SRC_URI="http://dev.gentoo.org/~bicatali/distfiles/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}"

src_install() {
	# rename because doman do not yet understand manl files
	# Not all systems have the rename command, like say FreeBSD
	local f t
	for f in MANPAGES/man/manl/*.l; do
		t="${f%%.l}.n"
		mv "${f}" "${t}" || die
	done
	doman MANPAGES/man/manl/*
	dodoc *.ps
}
