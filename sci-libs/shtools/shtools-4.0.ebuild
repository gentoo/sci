# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} == 9999 ]]; then
	ECLASS="git-r3"
	EGIT_REPO_URI="https://github.com/heroxbd/${PN^^}.git"
	S="${WORKDIR}"/${P}
else
	SRC_URI="https://github.com/${PN^^}/${PN^^}/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}"/${PN^^}-${PV/_/-}
fi

PYTHON_COMPAT=( python2_7 )

inherit python-r1 flag-o-matic toolchain-funcs ${ECLASS}

DESCRIPTION="Spherical harmonic transforms and reconstructions, rotations."
HOMEPAGE="http://shtools.ipgp.fr"

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="sci-libs/fftw:*
	sys-devel/gcc:*[fortran]
	virtual/lapack
	virtual/blas
	dev-python/numpy
	dev-python/matplotlib
	${PYTHON_DEPS}"

DEPEND="${RDEPEND}"

src_compile() {
	append-ldflags -shared # needed by f2py
	 # needed by f2py in fortran 77 mode
	use amd64 && append-fflags -fPIC
	OPTS=( LAPACK=$($(tc-getPKG_CONFIG) lapack --libs-only-l)
		BLAS=$($(tc-getPKG_CONFIG) blas --libs-only-l)
		FFTW=$($(tc-getPKG_CONFIG) fftw3 --libs-only-l)
		PYTHON_VERSION=2 )
	emake python ${OPTS[@]}
}

src_install() {
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${D}" ${OPTS[@]} install
}
