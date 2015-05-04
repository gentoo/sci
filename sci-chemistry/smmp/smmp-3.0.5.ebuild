# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit eutils fortran-2 python-r1 toolchain-funcs

MY_PN="SMMP"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Simple Molecular Mechanics for Proteins"
HOMEPAGE="http://smmp.berlios.de/"
SRC_URI="mirror://berlios/${PN}/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
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
		target="${PN}"
	fi

	emake ${target}
}

src_test() {
	emake examples
	cd EXAMPLES
	bash smmp.cmd || die
}

src_install() {
	dobin ${PN}
	installation() {
		python_moduleinto ${PN}
		python_domodule *.py
		python_optimize
	}
	python_foreach_impl installation
	dodoc README
}
