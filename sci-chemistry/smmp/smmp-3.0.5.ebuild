# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

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

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	mpi? ( virtual/mpi )"
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
	cd EXAMPLES || die
	bash smmp.cmd || die
}

src_install() {
	dobin ${PN}
	python_moduleinto ${PN}
	python_foreach_impl python_domodule *.py
	python_foreach_impl python_optimize
	dodoc README
}
