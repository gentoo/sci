# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == 9999 ]]; then
	_ECLASS="git-r3"
	EGIT_REPO_URI="https://github.com/heroxbd/${PN^^}.git"
	S="${WORKDIR}"/${P}
else
	SRC_URI="https://github.com/${PN^^}/${PN^^}/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}"/${PN^^}-${PV/_/-}
fi

PYTHON_COMPAT=( python{2_7,3_{4,5}} )

inherit fortran-2 flag-o-matic python-single-r1 toolchain-funcs ${_ECLASS}

DESCRIPTION="Spherical harmonic transforms and reconstructions, rotations"
HOMEPAGE="http://shtools.ipgp.fr"

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	sci-libs/fftw:3.0=
	virtual/lapack
	virtual/blas
	${PYTHON_DEPS}"

DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	append-ldflags -shared # needed by f2py
	# needed by f2py in fortran 77 mode
	append-fflags -fPIC
	[[ $(tc-getFC) =~ gfortran ]] && append-fflags -fno-second-underscore
	export _pyver=$(python_is_python3 && echo 3 || echo 2)
	export OPTS=(
		LAPACK=$($(tc-getPKG_CONFIG) lapack --libs-only-l)
		BLAS=$($(tc-getPKG_CONFIG) blas --libs-only-l)
		FFTW=$($(tc-getPKG_CONFIG) fftw3 --libs-only-l)
		F95=$(tc-getFC)
		F95FLAGS="${FCFLAGS}"
		AR=$(tc-getAR)
		RLIB=$(tc-getRANLIB)
		PYTHON_VERSION=${_pyver}
	)

	sed \
		-e '/mv/s:.so:*.so:g' \
		-e "/SYSDOCPATH/s:${PN}:${PF}:g" \
		-e "/www/s:/$:/html/:g" \
		-i Makefile || die

	default
}

src_compile() {
	emake fortran "${OPTS[@]}"
	emake python${_pyver} "${OPTS[@]}"
}

src_install() {
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${D}" "${OPTS[@]}" install-fortran
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${D}" "${OPTS[@]}" install-python${_pyver}
	if ! use static-libs; then
		rm -rf "${ED}"/usr/$(get_libdir)/*.a || die
	fi
}
