# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils flag-o-matic multilib

DESCRIPTION="EST sequence clustering by either of: d2 function, edit distance, common word heuristics"
HOMEPAGE="http://code.google.com/p/wcdest/"
SRC_URI="http://wcdest.googlecode.com/files/wcd-express-${PV}.tar.gz -> ${P}.tar.gz"

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

# consider providing the EMBOSS wrapper for wcd
# https://code.google.com/p/wcdest/downloads/detail?name=wcd_emboss_wrap_001.tar.gz

# also consider ESTsim
# https://code.google.com/p/wcdest/downloads/detail?name=estsim_distrib.tar.gz&can=2&q=
