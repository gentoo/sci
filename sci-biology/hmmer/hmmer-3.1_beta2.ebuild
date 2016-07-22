# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

MY_PV="3.1b2"
DESCRIPTION="Sequence analysis using profile hidden Markov models"
HOMEPAGE="http://hmmer.janelia.org/"
SRC_URI="http://eddylab.org/software/hmmer3/${MY_PV}/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE="+cpu_flags_x86_sse mpi +threads gsl static-libs"
KEYWORDS="~amd64"

DEPEND="
	mpi? ( virtual/mpi )
	gsl? ( >=sci-libs/gsl-1.12 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"${PN}"-"${MY_PV}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-fix_tests.patch \
		"${FILESDIR}"/${P}-perl-5.16-2.patch
}

src_configure() {
	econf \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_enable mpi) \
		$(use_enable threads) \
		$(use_with gsl)
}

src_install() {
	default

	use static-libs && dolib.a src/libhmmer.a easel/libeasel.a

	insinto /usr/share/${PN}
	doins -r tutorial
	dodoc Userguide.pdf
}
