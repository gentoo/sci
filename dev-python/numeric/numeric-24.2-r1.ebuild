# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs distutils eutils

MY_P=Numeric-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Numerical multidimensional array language facility to Python."
HOMEPAGE="http://numeric.scipy.org/"
SRC_URI="mirror://sourceforge/numpy/${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# lapack: compiles linear algebra from external optimized blas/cblas/lapack
IUSE="lapack"

# the blas stuff also needs a cblas implementation
# due to the current state of eselect blas/cblas, will force
# blas-atlas which provides both easily
DEPEND=">=dev-lang/python-2.3
	lapack? ( sci-libs/blas-atlas )
	lapack? ( virtual/lapack )"

src_unpack() {
	unpack ${A}
	# fix list problem
	epatch "${FILESDIR}"/${PN}-arrayobject.patch
	# adapt lapack support
	if use lapack; then
		epatch "${FILESDIR}"/${PN}-lapack.patch
		if  [[ $(gcc-major-version) -eq 4 ]]; then
			sed -i -e 's:g2c:gfortran:g' ${S}/customize.py
		fi
	fi
}


src_install() {
	distutils_src_install
	distutils_python_version

	# Numerical Tutorial is nice for testing and learning
	insinto /usr/$(get_libdir)/python${PYVER}/site-packages/NumTut
	doins Demo/NumTut/*

	# install various doc from packages
	docinto FFT
	dodoc Packages/FFT/MANIFEST
	docinto MA
	dodoc Packages/MA/{MANIFEST,README}
	docinto RNG
	dodoc Packages/RNG/{MANIFEST,README}
	docinto lapack_lite
	dodoc Misc/lapack_lite/README
	if use lapack; then
		docinto dotblas
		dodoc README.txt profileDot.*
	fi
}
