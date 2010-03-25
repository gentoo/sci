# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools

DESCRIPTION="MPI substitute library"
HOMEPAGE="http://wissrech.ins.uni-bonn.de/research/projects/nullmpi/"
SRC_URI="http://wissrech.ins.uni-bonn.de/research/projects/nullmpi/${PF}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}"

src_prepare() {
	eautoreconf || die "eautoreconf failed"
}

src_configure() {
	econf || die "econf failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
}
