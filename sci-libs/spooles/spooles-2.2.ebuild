# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib

MY_P=${PN}.${PV}

DESCRIPTION="SParse Object Oriented Linear Equations Solver"
HOMEPAGE="http://www.netlib.org/linalg/spooles"
SRC_URI="http://www.netlib.org/linalg/${PN}/${MY_P}.tgz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mpi threads"

DEPEND="mpi? ( virtual/mpi )"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${P}_makefiles.patch
	epatch "${FILESDIR}"/${P}_shared-libs.patch
	epatch "${FILESDIR}"/${P}_I2Ohash-64bit.patch
}

src_compile () {
	if use mpi; then
		epatch "${FILESDIR}"/${P}_MPI.patch
		sed -i -e "s|-lm|-lmpi -lm|" makefile
	fi

	if use threads; then
		epatch "${FILESDIR}"/${P}_MT.patch
		sed -i -e "s|-lm|-lpthread -lm|" makefile
	fi

	emake lib || die "emake failed"
}

src_install () {
	dolib *.a *.so.${PV} || die "dolib failed"
	dosym lib${PN}.so.${PV} /usr/$(get_libdir)/lib${PN}.so

	find . -name '*.h' -print0 | xargs -0 -n1 --replace=headerfile install -D headerfile tmp/headerfile
	insinto /usr/include/${PN}
	doins -r tmp/*
}
