# Copyright 1999-2009 Gentoo Foundation
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
IUSE="minimal openmp threads"

RDEPEND="!minimal? ( ( sci-chemistry/cns )
		x86? ( sci-chemistry/shelx )
	 )"
DEPEND="${RDEPEND}"
# Is there a way to get it build by the system scons?
# dev-util/scons"

#RESTRICT="mirror binchecks strip"

S="${WORKDIR}"
MY_S="${WORKDIR}"/cctbx_sources
MY_B="${WORKDIR}"/cctbx_build

MYCONF="${MY_S}/libtbx/configure.py"

src_unpack() {
	unpack ${A}

	# Wants to chmod /usr/bin/python
	epatch "${FILESDIR}"/${PV}-sandbox-violations-chmod.patch
	rm -rv "${MY_S}/clipper"
}

src_compile() {
	python_version

	MAKEOPTS_EXP=${MAKEOPTS/j/j }
	MAKEOPTS_EXP=${MAKEOPTS_EXP%-l[0-9]*}

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

	# Get LDFLAGS in format suitable for substitition into SConscript
	for i in ${LDFLAGS}; do
		OPTSLD="${OPTSLD} \"${i}\","
	done

	# Fix LDFLAGS which should be as-needed ready
	sed -i \
		-e "s:\"-shared\":${OPTSLD} \"-shared\":g" \
		${MY_S}/libtbx/SConscript

	# Get compiler in the right way
	COMPILER=$(expr match "$(tc-getCC)" '.*\([a-z]cc\)')
	MYCONF="${MYCONF} --compiler=${COMPILER}"

	# Precompiling python scripts. It is done in upstreams install script. Perhaps use python_mod_compile,
	# but as this script works we should stick to it.
	${python} "${MY_S}/libtbx/command_line/py_compile_all.py"

	# Additional USE flag usage
	check_use openmp
	MYCONF="${MYCONF} --enable-openmp-if-possible=${USE_openmp}"
	use threads && USEthreads="--enable-boost-threads" && \
	ewarn "If using boost threads openmp support is disabled"
	MYCONF="${MYCONF} ${USE_threads} --scan-boost"

	mkdir "${MY_B}" && MYCONF="${MYCONF} --current_working_directory=${MY_B}"
	cd "${MY_B}"

	MYCONF="${MYCONF} --build=release fftw3tbx rstbx smtbx mmtbx"
	einfo "configuring with ${python} ${MYCONF}"
#	${python} "${MY_S}"/libtbx/configure.py \
#		--compiler=${COMPILER} \
#		--current_working_directory="${MY_B}" \
#		--build=release \
#		--enable-openmp-if-possible="${USE_openmp}" \
#		${USE_threads} --scan-boost \
#		fftw3tbx rstbx smtbx mmtbx \

	${python} ${MYCONF} \
		|| die "configure failed"

	source setpaths_all.sh

	einfo "compiling with libtbx.scons ${MAKEOPTS_EXP}"
	libtbx.scons ${MAKEOPTS_EXP} .|| die "make failed"
}

src_test(){
	source "${MY_B}"/setpaths_all.sh
	libtbx.python $(libtbx.show_dist_paths boost_adaptbx)/tst_rational.py && \
	libtbx.python ${SCITBX_DIST}/run_tests.py ${MAKEOPTS_EXP} && \
	libtbx.python ${CCTBX_DIST}/run_tests.py  ${MAKEOPTS_EXP} \
	|| die "test failed"
}

src_install(){

	# This is what Bill Scott does in the fink package. Do we need this as well?
#	-e "s:prepend:append:g" \

	find cctbx_build/ -type f -exec \
	sed -e "s:${MY_S}:/usr/$(get_libdir)/cctbx/cctbx_sources:g" \
	    -e "s:${MY_B}:/usr/$(get_libdir)/cctbx/cctbx_build:g"  \
	    -i '{}' \; || die "Fail to correct path"


	insinto /usr/$(get_libdir)/${PN}
	doins -r cctbx_sources cctbx_build || die

	ebegin "removing unnessary files"
		rm -r "${D}"/usr/$(get_libdir)/${PN}/cctbx_sources/scons || die "failed to remove uneeded scons"
		find "${D}" -type f -name "*.o" -exec rm -f '{}' \; || die "failed to remove uneeded *.o"
	eend

	# using chmod as fperm only can manage one argumnet at a time
#	chmod 775 "${D}"/usr/$(get_libdir)/${PN}/cctbx_build/*sh && \
#	chmod 775 "${D}"/usr/$(get_libdir)/${PN}/cctbx_build/scitbx/array_family/* && \
#	chmod 775 "${D}"/usr/$(get_libdir)/${PN}/cctbx_build/scitbx/serialization/* && \
#	chmod 775 "${D}"/usr/$(get_libdir)/${PN}/cctbx_build/scitbx/error/* && \
#	chmod 775 "${D}"/usr/$(get_libdir)/${PN}/cctbx_build/scitbx/fftpack/timing/* && \
#	chmod 775 "${D}"/usr/$(get_libdir)/${PN}/cctbx_build/scitbx/lbfgs/* && \
#	chmod 775 "${D}"/usr/$(get_libdir)/${PN}/cctbx_build/scitbx/lbfgs/dev/* && \
#	chmod 775 "${D}"/usr/$(get_libdir)/${PN}/cctbx_build/chiltbx/handle_test && \
#	chmod 775 "${D}"/usr/$(get_libdir)/${PN}/cctbx_build/bin/* || \
#	die

	fperms 775 /usr/$(get_libdir)/${PN}/cctbx_build/*sh && \
	fperms 775 /usr/$(get_libdir)/${PN}/cctbx_build/scitbx/array_family/* && \
	fperms 775 /usr/$(get_libdir)/${PN}/cctbx_build/scitbx/serialization/* && \
	fperms 775 /usr/$(get_libdir)/${PN}/cctbx_build/scitbx/error/* && \
	fperms 775 /usr/$(get_libdir)/${PN}/cctbx_build/scitbx/fftpack/timing/* && \
	fperms 775 /usr/$(get_libdir)/${PN}/cctbx_build/scitbx/lbfgs/* && \
	fperms 775 /usr/$(get_libdir)/${PN}/cctbx_build/chiltbx/handle_test && \
	fperms 775 /usr/$(get_libdir)/${PN}/cctbx_build/bin/* || \
	die


	insinto /etc/profile.d/
	newins "${MY_B}"/setpaths.sh 30cctbx.sh && \
	newins "${MY_B}"/setpaths.csh 30cctbx.csh || \
	die

}


check_use(){

	for var in $@; do
	if use ${var}; then
	printf -v "USE_$var" True
	else
	printf -v "USE_$var" False

	fi
	shift
	done
}
