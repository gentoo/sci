# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils flag-o-matic multilib

DESCRIPTION="Sequence clustering by either of: d2 function, edit distance, common word heuristics"
HOMEPAGE="http://code.google.com/p/wcdest/"
SRC_URI="http://wcdest.googlecode.com/files/${P}B.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc mpi threads"

DEPEND="mpi? ( sys-cluster/mpich2 )"
RDEPEND=""

PATCHES=(
	"${FILESDIR}"/${P}-ldflags.patch
	"${FILESDIR}"/${P}-impl-decl.patch
	)

src_configure(){
	local myeconfargs=()
	use mpi && myeconfargs+=( --enable-mpi )

	use threads && myeconfargs+=( --enable-pthreads )

	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	use doc && autotools-utils_src_compile pdf info html
}

src_install() {
	use doc && HTML_DOCS=( doc/wcd.html doc/wcd.pdf doc/wcd.texi )
	autotools-utils_src_install PREFIX=/usr LIBDIR="${D}"usr/$(get_libdir)
}
