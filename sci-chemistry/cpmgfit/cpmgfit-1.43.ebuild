# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit fortran-2 multilib

DESCRIPTION="non-linear least squares fitting of CPMG relaxation dispersion curves"
HOMEPAGE="http://biochemistry.hs.columbia.edu/labs/palmer/software/cpmgfit.html"
SRC_URI="http://biochemistry.hs.columbia.edu/labs/palmer/software/cpmgfit.linux.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS=""
IUSE="examples"

RDEPEND="
	sci-libs/blas-reference
	=sys-devel/gcc-4.1*"
DEPEND="dev-util/patchelf"

S="${WORKDIR}"/linux

QA_PREBUILT="opt/bin/.*"

src_install() {
	local _exe

	exeinto /opt/bin
	if use x86; then
		_exe=./linux_32/${PN}
	elif use amd64; then
		_exe=./linux_64/${PN}
	fi

	patchelf --set-rpath "${EPREFIX}/opt/${PN}:${EPREFIX}/usr/$(get_libdir)/gcc/x86_64-pc-linux-gnu/4.1.2/" ${_exe}

	doexe ${_exe}

	dosym ../../usr/$(get_libdir)/librefblas.so /opt/${PN}/libblas.so.3

	dohtml ${PN}_manual.html

	if use examples; then
		insinto /usr/share/${PN}/examples/
		doins sample*
	fi
}
