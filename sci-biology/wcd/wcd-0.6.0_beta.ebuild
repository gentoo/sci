# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic

DESCRIPTION="wcd clusters sequences (typically ESTs) by either of: d2 function, edit distance, common word heuristics."
HOMEPAGE="http://code.google.com/p/wcdest"
SRC_URI="http://wcdest.googlecode.com/files/wcd-0.6.0B.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="mpi threads"

DEPEND="mpi? ( sys-cluster/mpich2 )"
RDEPEND=""

S="${WORKDIR}"/wcd-0.6.0

src_prepare(){
	mv "${DESTDIR}"/wcd-0.6.0B.tar.gz "${DESTDIR}"/wcd-0.6.0.tar.gz || die
}
	
src_compile(){
	local myconf=""
	if use mpi; then
		myconf="${myconf} --enable-mpi"
	fi

	if use threads; then
		myconf="${myconf} --enable-pthreads"
	fi

	econf ${myconf} || die

	emake || die
	emake pdf || die
	emake info || die
	emake html || die
}

src_install() {
	emake PREFIX=/usr DESTDIR="${D}" LIBDIR="${D}"usr/$(get_libdir) install \
		|| die "make install failed"
	for f in README doc/wcd.html doc/wcd.pdf doc/wcd.texi; do dodoc ${f} || die; done
}
