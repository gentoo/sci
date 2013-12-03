# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils

ELMER_ROOT="elmerfem"
MY_PN=${PN/elmer-/}

DESCRIPTION="Finite element programs, libraries, and visualization tools - elmer I/O library"
HOMEPAGE="http://www.csc.fi/english/pages/elmer"
SRC_URI="http://elmerfem.svn.sourceforge.net/viewvc/${ELMER_ROOT}/release/${PV}/${MY_PN}/?view=tar -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

S="${WORKDIR}/eio"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf $(use_with debug)
}
