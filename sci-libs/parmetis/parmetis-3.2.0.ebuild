# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/parmetis/parmetis-3.2.0.ebuild,v 1.2 2011/08/09 21:34:59 bicatali Exp $

EAPI=4
inherit eutils autotools

MYP=ParMetis-${PV}

DESCRIPTION="Parallel graph partitioner"
HOMEPAGE="http://www-users.cs.umn.edu/~karypis/metis/parmetis/"
SRC_URI="http://glaros.dtc.umn.edu/gkhome/fetch/sw/${PN}/OLD/${MYP}.tar.gz"
KEYWORDS="~amd64 ~x86"
LICENSE="free-noncomm"
SLOT="0"
IUSE="doc static-libs"

DEPEND="virtual/mpi"
RDEPEND="${DEPEND}
	!sci-libs/metis"

S="${WORKDIR}/${MYP}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.1.1-autotools.patch
	sed -i -e "s/3.1.1/${PV}/" configure.ac || die
	sed -i -e 's/order.c//' -e 's/lmatch.c//' ParMETISLib/Makefile.am || die
	eautoreconf
	export CC=mpicc
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	use doc && dodoc Manual/*.pdf
}
