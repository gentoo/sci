# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit toolchain-funcs python eutils

MY_PV="${PV//./_}"

DESCRIPTION="Computational Crystallography Toolbox"
HOMEPAGE="http://cctbx.sourceforge.net/"
SRC_URI="http://cci.lbl.gov/cctbx_build/results/${MY_PV}/${PN}_bundle.tar.gz -> ${P}.tar.gz"
LICENSE="cctbx-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="minimal openmp threads"

RDEPEND="!minimal? ( ( sci-chemistry/cns )
		x86? ( sci-chemistry/shelx )
	 )"
DEPEND="${RDEPEND}
	>=dev-util/scons-1.2"

S="${WORKDIR}"
MY_S="${WORKDIR}"/cctbx_sources
MY_B="${WORKDIR}"/cctbx_build

pkg_setup() {
	if use openmp &&
	[[ $(tc-getCC)$ == *gcc* ]] &&
		( [[ $(gcc-major-version)$(gcc-minor-version) -lt 42 ]] ||
		! built_with_use sys-devel/gcc openmp )
	then
		ewarn "You are using gcc and OpenMP is only available with gcc >= 4.2 "
		ewarn "If you want to build fftw with OpenMP, abort now,"
		ewarn "and switch CC to an OpenMP capable compiler"
	fi
}

src_prepare() {
	# Wants to chmod /usr/bin/python
	epatch "${FILESDIR}"/${PV}-sandbox-violations-chmod.patch

	rm -rf "${MY_S}/clipper" "${MY_S}/scons"  # "${MY_S}/boost"

	mkdir -p "${MY_S}"/scons/src/ "${MY_S}/boost"

	ln -sf /usr/$(get_libdir)/scons-1.2.0 "${MY_S}"/scons/src/engine || die
#	ln -sf /usr/include/boost "${MY_S}/boost/"
}

src_compile() {
	python_version

	local MYCONF
	local MAKEOPTS_EXP
	local OPTS
	local OPTSLD

	MYCONF="${MY_S}/libtbx/configure.py"

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

	local INST_DIR

	INST_DIR="/usr/${PN}"

	# This is what Bill Scott does in the fink package. Do we need this as well?
#	-e "s:prepend:append:g" \

	find cctbx_build/ -type f -exec \
	sed -e "s:${MY_S}:${INST_DIR}:g" \
	    -e "s:${MY_B}:/usr/:g"  \
	    -i '{}' \; || die "Fail to correct path"

	insinto "${INST_DIR}"
	doins "${MY_B}"/*.{csh,sh}

	cd ${MY_S}
	for i in $(find . -name "*.py" -exec dirname '{}' \;|sort|uniq); do
		insinto "${INST_DIR}/${i}"
		doins "${i}"/*.py
	done

	insinto "${INST_DIR}"/libtbx/command_line/
	doins libtbx/command_line/*.sh

	cd "${S}"

	dobin cctbx_build/bin/*

	insinto /usr/include
	doins -r cctbx_build/include/*

	insinto /usr/include/tntbx
	doins cctbx_sources/tntbx/include/*.h

	insinto /usr/include/
	doins -r cctbx_sources/cbflib_adaptbx/include/

	rm cctbx_build/lib/libboost_python.so
	dolib.so cctbx_build/lib/*

#	insinto /etc/profile.d/
#	newins "${MY_B}"/setpaths.sh 30cctbx.sh && \
#	newins "${MY_B}"/setpaths.csh 30cctbx.csh || \
#	die
}

pkg_postinst () {
	python_mod_optimize ${INST_DIR}
}

pkg_postrm () {
	python_mod_cleanup ${INST_DIR}
}

check_use() {

	for var in $@; do
	if use ${var}; then
	printf -v "USE_$var" True
	else
	printf -v "USE_$var" False

	fi
	shift
	done
}
