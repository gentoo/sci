# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils mpi toolchain-funcs

DESCRIPTION="Bayesian Inference of Phylogeny"
HOMEPAGE="http://mrbayes.csit.fsu.edu/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="mpi readline"

DEPEND="
	mpi? ( $(mpi_pkg_deplist) )
	readline? ( sys-libs/readline )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed \
		-e "s:OPTFLAGS ?= -O3:CFLAGS = ${CFLAGS}:" \
		-e "s:CC = gcc:CC = $(tc-getCC):" \
		-e "s:CC = mpicc:CC = $(mpi_pkg_cc):" \
		-e "s:LDFLAGS =:LDFLAGS ?=:" \
		-i Makefile || die "Patching CC/CFLAGS."
	if use mpi; then
		sed -e "s:MPI ?= no:MPI=yes:" -i Makefile || die "Patching MPI support."
	fi
	if ! use readline; then
		sed -e "s:USEREADLINE ?= yes:USEREADLINE=no:" \
			-i Makefile || die "Patching readline support."
	else
		# Only needed for OSX with an old (4.x) version of
		# libreadline, but it doesn't hurt for other distributions.
		epatch "${FILESDIR}"/mb_readline_312.patch
	fi
}

src_compile() {
	mpi_pkg_set_env
	emake || die
}

src_install() {
	mpi_dobin mb || die "Installation failed."
}
