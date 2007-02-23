# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/apbs/apbs-0.4.0.ebuild,v 1.5 2006/10/12 14:08:14 je_fro Exp $

inherit eutils fortran

MY_P="${P}-source-2"
S="${WORKDIR}"/"${MY_P}"

DESCRIPTION=" Software for evaluating the electrostatic properties of nanoscale biomolecular systems"
LICENSE="GPL-2"
HOMEPAGE="http://agave.wustl.edu/apbs/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

SLOT="0"
IUSE="blas mpi"
KEYWORDS="~ppc ~x86 ~amd64"

DEPEND="blas? ( virtual/blas )
		sys-libs/readline
		mpi? ( virtual/mpi )"

FORTRAN="g77 gfortran"

pkg_setup() {
	# It is important that you use the same compiler to compile
	# APBS that you used when compiling MPI.
	fortran_pkg_setup
}

src_unpack() {
	unpack ${A}
}

src_compile() {

	# use blas
	use blas && local myconf="--with-blas=-lblas"

	use mpi && myconf="${myconf} --with-mpiinc=/usr/include"

	econf ${myconf} || die "configure failed"

	# build
	make DESTDIR=${D} || die "make failed"
}

src_install() {

	# install apbs binary
	dobin bin/apbs || die "failed to install apbs binary"

	# remove useless files and install docs
	find ./examples -name 'test.sh' -exec rm -f {} \; || \
		die "Failed to remove test.sh files"
	find ./examples -name 'Makefile*' -exec rm -f {} \; || \
		die "Failed to remove Makefiles"
	find ./tools -name 'Makefile*' -exec rm -f {} \; || \
		die "Failed to remove Makefiles"

	dohtml -r doc/index.html doc/programmer doc/tutorial \
		doc/user-guide doc/license || \
			die "Failed to install html docs"
	
	insinto /usr/share/doc/${PF}/examples
	doins -r examples/* || \
		die "Failed to install examples"

	insinto /usr/share/${PF}/tools
	doins -r tools/* || die "failed to install tools"

}
