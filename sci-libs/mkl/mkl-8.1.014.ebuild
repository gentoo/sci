# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit fortran rpm flag-o-matic

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

intel_arch() {
	case ${ARCH} in
		amd64) echo "em64t"	;;
		ia64)  echo "64" ;;
		x86)   echo "32" ;;
	esac
}

MKL_LIB_DIR=lib/$(intel_arch)
	
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

	[ -z $(find ${WORKDIR} -name "*.rpm") ] \
		&& 	die "extracting the rpm failed"

	# clean up
	cd ${WORKDIR}
	rm -rf l_${PN}_p_${PV} tmp
	rm -rf `ls ${S}/lib/* | grep -v $(intel_arch)`
}

src_compile() {
	local arch=$(intel_arch)
	if use fortran95; then
		local fc=${FORTRANC}
		if [ "${FORTRANC}" = "ifc" ]; then
			fc=ifort
		fi
		for x in blas95 lapack95; do
			cd ${S}/interfaces/${x}
			make lib \
				PLAT=lnx${myplat/em64t/32e}
				FC=${fc} \
				INSTALL_DIR=${MKL_LIB_DIR} \
				|| die "make ${x} failed"
		done
	fi

	if use fftw; then
		for x in fftw2xc fftw2xf fftw3xc; do
			cd ${S}/interfaces/${x}
			make lib${arch} \
				F=gnu \
				|| die "make ${x} failed"
		done
		
	fi
}

src_test() {
	local fc="gnu"
	[ "${FORTRANC}" = "ifc" ] && fc="ifort"

	cd ${S}/tests
	for testdir in *; do
		einfo "Testing $testdir"
		cd ${testdir}
		emake so$(intel_arch) F=${fc} || die "make ${testdir} failed"
	done
}

src_install () {
	MKL_DIR=/opt/intel/${PN}/${MYPV}
	dodir ${MKL_DIR}
    cp -aurL doc include lib "${D}"/${MKL_DIR}
	if use examples; then
		insinto ${MKL_DIR}
		doins -r examples
	fi
	echo "INCLUDE=${MKL_DIR}/include"  > 35mkl
	echo "LD_LIBRARY_PATH=${MKL_DIR}/${MKL_LIB_DIR}" >> 35mkl
	doenvd 35mkl
}
