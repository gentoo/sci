# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils toolchain-funcs

MY_PN="SMMP"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Simple Molecular Mechanics for Proteins"
HOMEPAGE="http://smmp.berlios.de/"
SRC_URI="mirror://berlios/${PN}/${MY_P}.tar.bz2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
IUSE="doc mpi test"

RDEPEND="mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-flags.patch
}

src_compile() {
	if use mpi; then
		FC="mpif90"
		target="parallel"
	else
		FC=$(tc-getFC)
		target="${PN}"
	fi

	emake FC=${FC} ${target} || die

	if use test; then
		emake FC=${FC} examples || die
	fi
}

src_test() {
	cd EXAMPLES
	bash smmp.cmd || die
}

src_install() {
	dobin ${PN} || die
	insinto $(python_get_sitedir)/${PN}
	doins *.py || die
	dodoc README || die
}
