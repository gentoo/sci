# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils fortran-2 toolchain-funcs

DESCRIPTION="A DFT electronic structure code using a wavelet basis set"
HOMEPAGE="http://inac.cea.fr/L_Sim/BigDFT/"
SRC_URI="
	http://inac.cea.fr/L_Sim/BigDFT/${P}.tar.gz
	http://inac.cea.fr/L_Sim/BigDFT/${PN}-1.3.2.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cuda doc mpi test"

RDEPEND="
	=sci-libs/libxc-1*[fortran]
	virtual/blas
	virtual/fortran
	virtual/lapack
	mpi? ( virtual/mpi )
	cuda? ( dev-util/nvidia-cuda-sdk )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=sys-devel/autoconf-2.59
	doc? ( virtual/latex-base )"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-0001.patch \
		"${FILESDIR}"/${PN}-1.2.0.2-testH.patch

	rm -r src/PSolver/ABINIT-common
	mv ../${PN}-1.3.2/src/PSolver/ABINIT-common src/PSolver/
	sed -i -e's%@LIBXC_INCLUDE@%-I/usr/lib/finclude%g' \
		src/PSolver/ABINIT-common/Makefile.*
	sed -i -e's%config\.inc%config.h%g' \
		src/PSolver/ABINIT-common/*.F90
}

src_configure() {
	# fortran-2.eclass does not handle mpi wrappers
	if use mpi; then
		export FC="mpif90"
		export CC="mpicc"
	else
		tc-export FC CC
	fi

	econf \
		$(use_enable mpi) \
		--enable-libpoissonsolver \
		--enable-libbigdft \
		--enable-binaries \
		--with-moduledir=/usr/$(get_libdir)/finclude \
		--with-ext-linalg="`pkg-config --libs-only-l lapack`" \
		--with-ext-linalg-path="`pkg-config --libs-only-L lapack`" \
		--with-xc-module-path="/usr/lib/finclude" \
		$(use_enable cuda cuda-gpu) \
		$(use_with cuda cuda-path /opt/cuda) \
		$(use_with cuda lib-cutils /opt/cuda/lib) \
		FCFLAGS="${FCFLAGS:- ${FFLAGS:- -O2}}" \
		LD="$(tc-getLD)"
}

src_compile() {
	emake -j1 HAVE_ETSF_XC=1 || die "make failed"
	if use doc; then
		emake HAVE_ETSF_XC=1 doc || die "make doc failed"
	fi
}

src_test() {
	if use test; then
		emake check
	fi
}

src_install() {
	emake HAVE_ETSF_XC=1 DESTDIR="${D}" install || die "install failed"
	dodoc README INSTALL ChangeLog AUTHORS NEWS || die "dodoc failed"
}
