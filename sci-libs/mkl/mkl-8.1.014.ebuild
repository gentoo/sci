# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit fortran

MYPV=${PV/.014/}
DESCRIPTION="Intel(R) Math Kernel Library: linear algebra, fft, random number generators."
HOMEPAGE="http://www.intel.com/cd/software/products/asmo-na/eng/perflib/mkl/index.htm"
SRC_URI="l_${PN}_p_${PV}.tgz"
RESTRICT="nostrip fetch"

IUSE="fortran95 fftw examples"
SLOT="0"
LICENSE="mkl-8.1"
KEYWORDS="~x86 ~amd64 ~ia64"
DEPEND="virtual/libc"

get_intel_arch() {
	local lib
	local del
	case ${ARCH} in
		amd64) lib=em64t del="32 64"	;;
		ia64)  lib=64 del="32 em64t" ;;
		x86)   lib=32 del="64 em64t" ;;
	esac
	[ ${1} = "lib" ] && echo "${lib}"
	[ ${1} = "del" ] && echo "${del}"
}

get_intel_fortran() {
	if [ "${FORTRANC}" = "ifc" ]; then
		echo ifort
	else
		echo g77
	fi
}

get_intel_c() {
	echo gnu
}

MKL_LIB_DIR=lib/$(get_intel_arch lib)
	
pkg_nofetch() {
	einfo "Please download the intel mkl from:"
	einfo "http://www.intel.com/software/products/mkl/downloads/lin_mkl.htm"
	einfo "and place it in ${DISTDIR}"
	einfo "Also you need to register in ${HOMEPAGE}"
	einfo "and keep the license Intel sent you"
	ewarn "This version is only available through http://premier.intel.com"
}

pkg_setup() {

	if use fortran95; then
		FORTRAN="ifc gfortran"
		fortran_pkg_setup
	fi
	if has test ${FEATURES}; then
		FORTRAN="${FORTRAN} g77"
	fi
	if  [ -z "${INTEL_LICENSE}" ] &&
		[ -z "$(find /opt/intel/licenses -name *mkl*.lic)" ]; then
		eerror "Did not find any valid mkl license."
		eerror "Please locate your license file and run:"
		eerror "\t INTEL_LICENSE=/my/license/files emerge ${PN}"
		eerror "or place your license in /opt/intel/licenses"
		eerror "Hint: the license file is in the email Intel sent you" 
		die
	fi
}

# the whole shmol is to extract rpm files non-interactively
# from the big mkl installation
# hopefully recyclable for ipp
src_unpack() {

	ewarn
	ewarn "Intel ${PN} requires 200Mb of disk space"
	ewarn "Make sure you have enough space on /var and also in /opt/intel"
	ewarn

	unpack ${A}	
	cd ${WORKDIR}/l_${PN}_p_${PV}/install
	# answer file to make the big install script non-interactive
	echo $"
[${PN}_install]
EULA_ACCEPT_REJECT=accept
FLEXLM_LICENSE_LOCATION=${INTEL_LICENSE}
TEMP_DIR=${WORKDIR}/tmp
INSTALL_DESTINATION=${S}" > answers.txt

	einfo "Building rpm file..."
	addwrite "/opt/intel"
	./install \
		--noroot \
		--nonrpm \
		--installpath ${S} \
		--silent answers.txt &> /dev/null
	
	[ -z $(find ${WORKDIR} -name "libvml.so") ] \
		&& 	die "extracting the rpm failed"

	cd ${WORKDIR}
	rm -rf l_${PN}_p_${PV} tmp
	for d in $(get_intel_arch del); do		
		rm -rf ${S}/lib/${d}
	done
}

src_compile() {
	if use fortran95; then
		for x in blas95 lapack95; do
			cd ${S}/interfaces/${x}
			emake lib \
				PLAT=lnx${myplat/em64t/32e}
				FC=$(intel_fortran) \
				INSTALL_DIR=${MKL_LIB_DIR} \
				|| die "make ${x} failed"
		done
	fi

	if use fftw; then
		for x in fftw2xc fftw2xf fftw3xc; do
			cd ${S}/interfaces/${x}
			emake lib$(get_intel_arch lib) \
				F=$(get_intel_c) \
				|| die "make ${x} failed"
		done
		
	fi
}

src_test() {
	for testdir in ${S}/tests/*; do
		einfo "Testing $testdir"
		cd ${testdir}
		emake so$(get_intel_arch lib) \
			FC=$(get_intel_fortran) \
			F=$(get_intel_c) \
			|| die "make ${testdir} failed"
	done
}

src_install () {
	MKL_DIR=/opt/intel/${PN}/${MYPV}
	dodir ${MKL_DIR}
	cp -pPR doc include lib "${D}"/${MKL_DIR}
	if use examples; then
		insinto ${MKL_DIR}
		doins -r examples
	fi
	echo "INCLUDE=${MKL_DIR}/include"  > 35mkl
	echo "LD_LIBRARY_PATH=${MKL_DIR}/${MKL_LIB_DIR}" >> 35mkl
	doenvd 35mkl
}

