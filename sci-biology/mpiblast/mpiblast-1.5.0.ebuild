# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/amos/amos-2.0.8.ebuild,v 1.1 2008/08/26 16:33:07 weaver Exp $

EAPI="2"

inherit eutils

DESCRIPTION="An MPI implementation of NCBI BLAST"
HOMEPAGE="http://www.mpiblast.org/"
SRC_URI="http://www.mpiblast.org/downloads/files/mpiBLAST-${PV}-pio.tgz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND="virtual/mpi
	app-shells/tcsh"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-pio"

src_configure() {
	epatch "${FILESDIR}"/${P}-*.patch
}

src_compile() {
	# configure also runs build
	econf
}

src_install() {
	emake DESTDIR="${D}" install || die
}
