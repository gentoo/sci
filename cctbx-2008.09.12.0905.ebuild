# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs python eutils

MY_PV="${PV//./_}"

DESCRIPTION="Computational Crystallography Toolbox"
HOMEPAGE="http://cctbx.sourceforge.net/"
#SRC_URI="mirror://gentoo/cctbx_bundle-${PV}.tar.gz"
SRC_URI="http://gentoo.j-schmitz.net/portage/distfiles/${CATEGORY}/${PN}/${P}.tar.gz"
LICENSE="cctbx-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="openmp threads"

## CNS/shelx
RDEPEND=""
DEPEND="dev-util/scons"
RESTRICT="mirror"

S="${WORKDIR}"
MY_S="${WORKDIR}"/cctbx_sources
MY_B="${WORKDIR}"/cctbx_build

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${PV}-config.py.patch
}

src_compile() {
	python_version

	MAKEOPTS_EXP=${MAKEOPTS/j/j }
	MAKEOPTS_EXP=${MAKEOPTS_EXP%-l[0-9]}

	# Get CXXFLAGS in format suitable for substitition into SConscript
	for i in ${CXXFLAGS}; do
		OPTS="${OPTS} \"${i}\","
	done

	# Strip off the last comma
	OPTS=${OPTS%,}

	# Fix CXXFLAGS
	sed -i \
		-e "s:\"-O3\", \"-ffast-math\":${OPTS}:g" \
		${MY_S}/libtbx/SConscript

	# Get compiler in the right way
	COMPILER=$(expr match "$(tc-getCC)" '.*\([a-z]cc\)')

	einfo "Precompiling python scripts"
	${python} "${MY_S}/libtbx//command_line/py_compile_all.py"

	check_use openmp

	use threads && USEthreads="--enable-boost-threads" && \
	ewarn "If using boost threads openmp support is disabled"

	mkdir "${MY_B}"
	cd "${MY_B}"

	einfo "configuring ...."
	${python} "${MY_S}"/libtbx/configure.py \
		--compiler=${COMPILER} \
		--current_working_directory="${MY_B}" \
		--build=release \
		--enable-openmp-if-possible="${USEopenmp}" \
		${USEthreads} --scan-boost \
		fftw3tbx rstbx smtbx mmtbx \
		|| die "configure failed"
#		fftw3tbx rstbx smtbx mmtbx clipper \
	source setpaths_all.sh # source setpaths.csh

#	einfo "compiling ..."
	libtbx.scons ${MAKEOPTS_EXP} .|| die "make failed"
}

src_test(){
#	adjust_exec_bits ${MY_B}

	source "${MY_B}"/setpaths_all.sh
	libtbx.python $(libtbx.show_dist_paths boost_adaptbx)/tst_rational.py && \
	libtbx.python ${SCITBX_DIST}/run_tests.py ${MAKEOPTS_EXP} && \
	libtbx.python ${CCTBX_DIST}/run_tests.py  ${MAKEOPTS_EXP} \
	|| die "test failed"
}

src_install(){

	find cctbx_build/ -type f -exec \
	sed -e "s:${MY_S}:/usr/$(get_libdir)/cctbx/cctbx_sources:g" \
	    -e "s:${MY_B}:/usr/$(get_libdir)/cctbx/cctbx_build:g"  \
	    -i '{}' \; || die "Fail to correct path"
#    -e "s:prepend:append:g" \
#

	insinto /usr/$(get_libdir)/${PN}
	doins -r cctbx_sources cctbx_build

	rm -r "${D}"/cctbx_sources/scons

	fperms 775 /usr/$(get_libdir)/${PN}/cctbx_build/*sh
	fperms 775 /usr/$(get_libdir)/${PN}/cctbx_build/bin/*


	insinto /etc/profile.d/
	newins "${MY_B}"/setpaths.sh 30cctbx.sh
	newins "${MY_B}"/setpaths.csh 30cctbx.csh

}


check_use(){

	for VARI in $*; do
		if use $1; then
			eval USE$1="True"
		else
			eval USE$1="False"

		fi
	shift
	done
}

adjust_exec_bits(){

	chmod 775 ${1}/*sh
	chmod 775 ${1}/bin/*

}
