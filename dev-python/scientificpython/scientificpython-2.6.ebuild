# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P=${P/scientificpython/ScientificPython}
S=${WORKDIR}/${MY_P}
DV=1034 # hardcoded download version
inherit distutils

IUSE="mpi"
DESCRIPTION="Scientific Module for Python"
SRC_URI="http://sourcesup.cru.fr/frs/download.php/${DV}/${MY_P}.tar.gz"
HOMEPAGE="http://dirac.cnrs-orleans.fr/ScientificPython/"
SLOT="0"
LICENSE="CeCILL-2"
KEYWORDS="~amd64 ~x86"

DEPEND="virtual/python
	>=dev-python/numeric-23.0
	>=sci-libs/netcdf-3.0
	mpi? ( virtual/mpi )"


src_install() {
	distutils_src_install

	dodoc MANIFEST.in README*
	dodoc Doc/CHANGELOG
	dohtml Doc/Reference/*
	insinto /usr/share/doc/${PF}/
	doins Doc/*.pdf
	doins -r Examples
	if use mpi; then
		cd Src/MPI
		python compile.py
		dobin mpipython || die "dobin failed"
	fi
}
