# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs fortran check-reqs

PID=967
PB=${PN}
DESCRIPTION="Intel(R) Math Kernel Library: linear algebra, fft, math functions"
HOMEPAGE="http://developer.intel.com/software/products/mkl/"

KEYWORDS="~amd64 ~ia64 ~x86"
SRC_URI="http://registrationcenter-download.intel.com/irc_nas/${PID}/l_${PN}_p_${PV}.tgz"

#slotting not yet supported (need eselect-mkl)
#MAJOR=$(get_major_version ${PV})
#MINOR=$(get_version_component_range 2 ${PV})
#SLOT="${MAJOR}.${MINOR}"

SLOT="0"
LICENSE="Intel-SDP"

IUSE="doc fftw fortran95 int64 mpi"
RESTRICT="strip mirror"

DEPEND="app-admin/eselect-blas
	app-admin/eselect-cblas
	app-admin/eselect-lapack"

RDEPEND="${DEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/blas-docs app-doc/lapack-docs )
	mpi? ( virtual/mpi )"

MKL_DIR=/opt/intel/${PN}/${PV}
INTEL_LIC_DIR=/opt/intel/licenses

pkg_setup() {

	# Check the license
	[[ -z ${MKL_LICENSE} && -d ${INTEL_LIC_DIR} ]] && \
		MKL_LICENSE=$(find ${ROOT}/${INTEL_LIC_DIR} -name "*MKL*.lic" | tail -n 1)
	if  [[ -z ${MKL_LICENSE} ]]; then
		eerror "Did not find any valid mkl license."
		eerror "Register at ${HOMEPAGE} to receive a license"
		eerror "and place it in ${INTEL_LIC_DIR} or run:"
		eerror "\t MKL_LICENSE=/my/license/dir emerge mkl"
		die "license setup failed"
	fi

	# Check if we have enough free diskspace to install
	CHECKREQS_DISK_BUILD="1100"
	check_reqs

	# Check and setup fortran
	FORTRAN="gfortran ifc g77"
	if use fortran95; then
		FORTRAN="gfortran ifc"
		# blas95 and lapack95 don't compile with gfortran < 4.2
		gcc-version lt 4 2 && FORTRAN="ifc"
	fi
	use int64 && FORTRAN="gfortran ifc"
	fortran_pkg_setup
	MKL_FC="gnu"
	[[ ${FORTRANC} == if* ]] && MKL_FC="intel"

	# build profiles according to what compiler is installed
	MKL_CC="gnu"
	[[ $(tc-getCC) == icc ]] && MKL_CC="intel"

	if has_version sys-cluster/mpich; then
		MKL_MPI=mpich
	elif has_version sys-cluster/mpich2; then
		MKL_MPI=mpich2
	elif has_version sys-cluster/openmpi; then
		MKL_MPI=openmpi
	elif has_version sys-cluster/lam-mpi; then
		MKL_MPI=lam-mpi
	else
		MKL_MPI=intelmpi
	fi
}

src_unpack() {

	unpack ${A}
	cd l_${PN}_*_${PV}/install

	cp ${MKL_LICENSE} "${WORKDIR}"/
	MKL_LIC="$(basename ${MKL_LICENSE})"

	# binary blob extractor installs rpm leftovers in /opt/intel
	addwrite /opt/intel
	# undocumented features: INSTALLMODE_mkl=NONRPM

	# We need to install mkl non-interactively.
	# If things change between versions, first do it interactively:
	# tar xf l_*; ./install.sh --duplicate mkl.ini;
	# The file will be instman/mkl.ini
	# Then check it and modify the ebuild-created one below
	# --norpm is required to be able to install 10.x
	cat > mkl.ini <<-EOF
		[MKL]
		EULA_ACCEPT_REJECT=ACCEPT
		FLEXLM_LICENSE_LOCATION=${WORKDIR}/${MKL_LIC}
		INSTALLMODE_mkl=NONRPM
		INSTALL_DESTINATION=${S}
	EOF
	einfo "Extracting ..."
	./install \
		--silent ./mkl.ini \
		--installpath "${S}" \
		--log log.txt &> /dev/null

	if [[ -z $(find "${S}" -name libmkl.so) ]]; then
		eerror "Could not find extracted files"
		eerror "See ${PWD}/log.txt to see why"
		die "extracting failed"
	fi

	# remove unused stuff and set up intel names
	rm -rf "${WORKDIR}"/l_*

	cd "${S}"
	# allow openmpi to work
	epatch "${FILESDIR}"/${P}-openmpi.patch
	# make scalapack tests work for gfortran
	epatch "${FILESDIR}"/${P}-tests.patch
	case ${ARCH} in
		x86)	MKL_ARCH=32
				MKL_KERN=ia32
				rm -rf lib*/{em64t,64}
				;;

		amd64)	MKL_ARCH=em64t
				MKL_KERN=em64t
				rm -rf lib*/{32,64}
				;;

		ia64)	MKL_ARCH=64
				MKL_KERN=ipf
				rm -rf lib*/{32,em64t}
				;;
	esac
	MKL_LIBDIR=${MKL_DIR}/lib/${MKL_ARCH}
}

src_compile() {
	cd "${S}"/interfaces
	if use fortran95; then
		einfo "Compiling fortan95 static lib wrappers"
		local myconf="lib${MKL_ARCH}"
		[[ ${FORTRANC} == gfortran ]] && \
			myconf="${myconf} FC=gfortran"
		if use int64; then
			myconf="${myconf} interface=ilp64"
			[[ ${FORTRANC} == gfortran ]] && \
				myconf="${myconf} FOPTS=-fdefault-integer-8"
		fi
		for x in blas95 lapack95; do
			pushd ${x}
			emake ${myconf} || die "emake ${x} failed"
			popd
		done
	fi

	if use fftw; then
		local fftwdirs="fftw2xc fftw2xf fftw3xc fftw3xf"
		local myconf="lib${MKL_ARCH} compiler=${MKL_CC}"
		if use mpi; then
			fftwdirs="${fftwdirs} fftw2x_cdft"
			myconf="${myconf} mpi=${MKL_MPI}"
		fi
		einfo "Compiling fftw static lib wrappers"
		for x in ${fftwdirs}; do
			pushd ${x}
			emake ${myconf} || die "emake ${x} failed"
			popd
		done
	fi
}

src_test() {
	cd "${S}"/tests
	local myconf
	local testdirs="blas cblas"
	use int64 && myconf="${myconf} interface=ilp64"
	if use mpi; then
		testdirs="${testdirs} scalapack"
		myconf="${myconf} mpi=${MKL_MPI}"
	fi
	for x in ${testdirs}; do
		pushd ${x}
		einfo "Testing ${x}"
		emake \
			compiler=${MKL_FC} \
			${myconf} \
			so${MKL_ARCH} \
			|| die "emake ${x} failed"
		popd
	done
}

mkl_make_generic_profile() {
	cd "${S}"
	# produce eselect files
	# don't make them in FILESDIR, it changes every major version
	cat  > eselect.blas <<-EOF
		${MKL_LIBDIR}/libmkl_${MKL_KERN}.a /usr/@LIBDIR@/libblas.a
		${MKL_LIBDIR}/libmkl.so /usr/@LIBDIR@/libblas.so
		${MKL_LIBDIR}/libmkl.so /usr/@LIBDIR@/libblas.so.0
	EOF
	cat  > eselect.cblas <<-EOF
		${MKL_LIBDIR}/libmkl_${MKL_KERN}.a /usr/@LIBDIR@/libcblas.a
		${MKL_LIBDIR}/libmkl.so /usr/@LIBDIR@/libcblas.so
		${MKL_LIBDIR}/libmkl.so /usr/@LIBDIR@/libcblas.so.0
		${MKL_DIR}/include/mkl_cblas.h /usr/include/cblas.h
	EOF
	cat > eselect.lapack <<-EOF
		${MKL_LIBDIR}/libmkl_lapack.a /usr/@LIBDIR@/liblapack.a
		${MKL_LIBDIR}/libmkl_lapack.so /usr/@LIBDIR@/liblapack.so
		${MKL_LIBDIR}/libmkl_lapack.so /usr/@LIBDIR@/liblapack.so.0
	EOF
}

# usage: mkl_add_profile <profile> <interface_lib> <thread_lib> <rtl_lib>
mkl_add_profile() {
	cd "${S}"
	local prof=${1}
	insinto ${MKL_LIBDIR}
	for x in blas cblas lapack; do
		cat > ${x}-${prof}.pc <<-EOF
			prefix=/usr
			libdir=${MKL_LIBDIR}
			includedir=${prefix}/include
			Name: ${x}
			Description: Intel(R) Math Kernel Library implementation of ${p}
			Version: ${PV}
			URL: ${HOMEPAGE}
			Libs: -L\${libdir} ${2} ${3} -lmkl_core ${4} -lpthread
		EOF
		cp eselect.${x} eselect.${x}.${prof}
		echo "${MKL_LIBDIR}/${x}-${prof}.pc /usr/@LIBDIR@/pkgconfig/${x}.pc" \
			>> eselect.${x}.${prof}
		doins ${x}-${prof}.pc
		eselect ${x} add $(get_libdir) eselect.${x}.${prof} ${prof}
	done
}

mkl_make_profiles() {
	local clib
	has_version 'dev-lang/ifc' && clib="intel"
	built_with_use sys-devel/gcc fortran && clib="${clib} gf"
	local slib="-lmkl_sequential"
	local rlib="-liomp5"
	for c in ${clib}; do
		local ilib="-lmkl_${c}_lp64"
		use x86 && ilib="-lmkl_${c}"
		local tlib="-lmkl_${c/gf/gnu}_thread"
		local comp="${c/gf/gfortran}"
		comp="${comp/intel/ifort}"
		mkl_add_profile mkl-${comp} ${ilib} ${slib}
		mkl_add_profile mkl-${comp}-threads ${ilib} ${tlib} ${rlib}
		if use int64; then
			ilib="-lmkl_${c}_ilp64"
			mkl_add_profile mkl-${comp}-int64 ${ilib} ${slib}
			mkl_add_profile mkl-${comp}-threads-int64 ${ilib} ${tlib} ${rlib}
		fi
	done
}

src_install() {
	dodir ${MKL_DIR}
	# upstream installs a link, no idea why
	dosym ${MKL_DIR} ${MKL_DIR/mkl/cmkl}

	# install license
	if  [[ ! -f ${INTEL_LIC_DIR}/${MKL_LIC} ]]; then
		insinto ${INTEL_LIC_DIR}
		doins "${WORKDIR}"/${MKL_LIC} || die "install license failed"
	fi

	# install main stuff: cp faster than doins
	einfo "Installing files..."
	local cpdirs="benchmarks doc examples include interfaces lib man tests"
	local doinsdirs="tools"
	cp -pPR ${cpdirs} "${D}"${MKL_DIR} \
		|| die "installing mkl failed"
	doins ${doinsdirs} || die "doins ${doinsdirs} failed"

	# install blas/lapack profiles
	mkl_make_generic_profile
	mkl_make_profiles

	# install env variables
	local env_file=35mkl
	echo "LDPATH=${MKL_LIBDIR}" > ${env_file}
	echo "MANPATH=${MKL_DIR}/man" >> ${env_file}
	doenvd ${env_file} || die "doenvd failed"
}

pkg_postinst() {
	# if blas profile is mkl, set lapack and cblas profiles as mkl
	local blas_lib=$(eselect blas show | cut -d' ' -f2)
	local def_prof="mkl-gfortran-threads"
	has_version 'dev-lang/ifc' && def_prof="mkl-ifort-threads"
	use int64 && def_prof="${def_prof}-int64"
	for x in blas cblas lapack; do
		local current_lib=$(eselect ${x} show | cut -d' ' -f2)
		if [[ -z ${current_lib} || \
			${current_lib} == mkl* || \
			${blas_lib} == mkl* ]]; then
			# work around eselect bug #189942
			local configfile="${ROOT}"/etc/env.d/${x}/$(get_libdir)/config
			[[ -e ${configfile} ]] && rm -f ${configfile}
			eselect ${x} set ${def_prof}
			elog "${x} has been eselected to ${def_prof}"
			if [[ ${current_lib} != ${blas_lib} ]]; then
				eselect blas set ${def_prof}
				elog "${x} is now set to ${def_prof} for consistency"
			fi
		else
			elog "Current eselected ${x} is ${current_lib}"
			elog "To use one of mkl profiles, issue (as root):"
			elog "\t eselect ${x} set <profile>"
		fi
	done
}
