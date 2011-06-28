# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils flag-o-matic

DESCRIPTION="Sequence clustering by either of: d2 function, edit distance, common word heuristics"
HOMEPAGE="http://code.google.com/p/wcdest/"
SRC_URI="http://wcdest.googlecode.com/files/${P}B.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc mpi threads"

DEPEND="mpi? ( sys-cluster/mpich2 )"
RDEPEND=""

S="${WORKDIR}"/wcd-0.6.0

src_configure(){
	local myconf=""
	if use mpi; then
		myconf="${myconf} --enable-mpi"
	fi

	if use threads; then
		myconf="${myconf} --enable-pthreads"
	fi

	econf ${myconf}
}

src_compile() {
	emake
	if use doc; then
		emake pdf info html
	fi
}

src_install() {
	local f
	emake PREFIX=/usr DESTDIR="${D}" LIBDIR="${D}"usr/$(get_libdir) install

	if use doc; then
		for f in README doc/wcd.html doc/wcd.pdf doc/wcd.texi; do
			dodoc ${f}
		done
	fi
}
