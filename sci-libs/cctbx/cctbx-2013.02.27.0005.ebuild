# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/cctbx/cctbx-2010.03.29.2334-r7.ebuild,v 1.3 2013/03/19 07:07:15 jlec Exp $

EAPI=5

DISTUTILS_SINGLE_IMPL=true
PYTHON_COMPAT=( python{2_6,2_7} )

inherit  distutils-r1 eutils fortran-2 multilib toolchain-funcs

MY_PV="${PV//./_}"

DESCRIPTION="Computational Crystallography Toolbox"
HOMEPAGE="http://cctbx.sourceforge.net/"
SRC_URI="http://cci.lbl.gov/cctbx_build/results/${MY_PV}/${PN}_bundle.tar.gz -> ${P}.tar.gz"

LICENSE="cctbx-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+minimal static-libs"

RDEPEND="
	>=dev-libs/boost-1.48[python,${PYTHON_USEDEP}]
	sci-libs/clipper
	sci-libs/fftw:2.1
	sci-libs/libccp4
	!minimal? (
		sci-chemistry/cns
		sci-chemistry/shelx )"
DEPEND="${RDEPEND}
	!prefix? ( >=dev-util/scons-1.2[${PYTHON_USEDEP}] )"

S="${WORKDIR}"
MY_S="${WORKDIR}"/cctbx_sources
MY_B="${WORKDIR}"/cctbx_build

pkg_setup() {
	if ! tc-has-openmp; then
		ewarn "You are using gcc and OpenMP is only available with gcc >= 4.2 and icc"
		ewarn "If you want to build ${PN} with OpenMP, abort now,"
		ewarn "and switch CC to an OpenMP capable compiler"
	fi
	python-single-r1_pkg_setup
}

python_prepare_all() {
	local opts
	local optsld

	EPATCH_OPTS="-p1" \
	epatch \
		"${FILESDIR}"/${PV}/*patch

	export MULTILIBDIR=$(get_libdir)

	# Clean sources
	rm -rf "${MY_S}"/boost/* || die
	rm -rf "${MY_S}"/PyCifRW/* || die
	find "${MY_S}"/cbflib -maxdepth 1 -mindepth 1 -not -name examples -exec rm -rf {} + || die
	find "${MY_S}"/ccp4io/lib -maxdepth 1 -mindepth 1 -not -name ssm -exec rm -rf {} + || die
	find "${MY_S}"/clipper -maxdepth 1 -mindepth 1 -not -name clipper -exec rm -rf {} + || die
#	find "${MY_S}"/clipper/clipper -maxdepth 1 -mindepth 1 \( -not -name cctbx -a -not -name contrib \) -exec rm -rf {} + || die
	find "${MY_S}"/clipper/clipper -maxdepth 1 -mindepth 1 -not -name cctbx -exec rm -rf {} + || die
	rm -rf "${MY_S}"/gui_resources/gl2ps || die
#	rm -rf "${MY_S}"/scons || die
	rm -rf "${MY_S}"/ucif/antlr3 || die
#	rm -rvf "${MY_S}"/ccp4io/lib/ssm || die

#	find "${MY_S}/clipper" -name "*.h" -print -delete >> "${T}"/clean.log || die

	if ! use prefix; then
		rm -rvf "${MY_S}/scons" >> "${T}"/clean.log || die
		echo "import os, sys; os.execvp('scons', sys.argv)" > "${MY_S}"/libtbx/command_line/scons.py || die
	fi

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	if ! use static-libs; then
		find "${ED}" -type f -name "*.a" -delete || die
	fi
	prune_libtool_files
}
