# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit fortran rpm flag-o-matic

MYPV=${PV/.006/}
DESCRIPTION="Intel(R) Math Kernel Library: linear algebra, fft, random number generators."
HOMEPAGE="http://developer.intel.com/software/products/mkl/"
SRC_URI="l_${PN}_p_${PV}.tgz"
RESTRICT="nostrip fetch"

#fortran95 implements a fortran 95 blas/lapack interface
IUSE="fortran95 examples"
SLOT="0"
LICENSE="mkl-8.0.1"
KEYWORDS="~x86 ~amd64 ~ia64"
DEPEND="virtual/libc
	sci-libs/lapack-config
	sci-libs/blas-config"

PROVIDE="virtual/blas
	     virtual/lapack"


S="${WORKDIR}/l_${PN}_p_${PV}"
INSTDIR=opt/intel/${PN}/${MYPV}


pkg_setup() {

	if use fortran95; then
		FORTRAN="ifc gfortran"
		fortran_pkg_setup
	fi

    if  [ -z "${INTEL_LICENSE}" ] && \
		[ -z $(find /opt/intel/licenses -name *mkl*.lic) ]; then
		eerror "Did not find any valid mkl license."
		eerror "Please locate your license file and run:"
		eerror "\t INTEL_LICENSE=/my/license/files emerge ${PN}"
		eerror "or place your license in /opt/intel/licenses and run emerge ${PN}"
		einfo
		einfo "http://www.intel.com/cd/software/products/asmo-na/eng/perflib/mkl/219859.htm"
		einfo "From the above url you can get a free, non-commercial"
		einfo "license to use the Intel Math Kernel Libary emailed to you."
		einfo "You cannot use mkl without this license file."
		einfo "Read the website for more information on this license."
		einfo
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
		
	# fake rpm commands to trick the big install script
	mkdir -p bin
	echo "exit 1" > bin/rpm2cpio
	echo "exit 1" > bin/rpm
	chmod +x bin/*
	PATH=".:${PATH}:$PWD/bin"

	cd ${S}/install
	# answer file to make the big install script non-interactive
	echo $"
[${PN}_install]
EULA_ACCEPT_REJECT=accept
FLEXLM_LICENSE_LOCATION=${INTEL_LICENSE}
TEMP_DIR=${WORKDIR}/rpm
INSTALL_DESTINATION=${S}
RPM_INSTALLATION=
" > answers.txt

	einfo "Building rpm file..."
	./install \
		--noroot \
		--nonrpm \
		--installpath ${S} \
		--silent answers.txt &> /dev/null

	[ -z $(find ${WORKDIR} -name "*.rpm") ] \
		&& 	die "error while extracting the rpm"

	rm -rf ${WORKDIR}/bin ${S}/*

	cd ${S}
	for x in $(ls ../rpm/*.rpm); do
		einfo "Extracting $(basename ${x})..."
		rpm_unpack ${x} || die "rpm_unpack failed"
	done

	# clean up
	rm -rf ${WORKDIR}/rpm
    rm -rf ${S}/${INSTDIR}/tools/environment
}

src_compile() {

	case ${ARCH} in
		amd64)
			IARCH="em64t"
			IKERN="em64t"
			;;
		ia64)
			IARCH="64"
			IKERN="ipf"
			;;
		x86)
			IARCH="32"
			IKERN="ia32"
			;;
	esac
	ILIBDIR=${INSTDIR}/lib/${IARCH}
	einfo "IARCH=$IARCH IKERN=$IKERN"

	cd ${S}/${INSTDIR}/tools/builder
	for x in blas cblas lapack; do
		#cp ${x}_list ${x}.mylist
		#echo "xerbla_" >> ${x}.mylist
		#echo "ilaenv_" >> ${x}.mylist
		make ${IKERN} export=${FILESDIR}/${x}.list name=libmkl_${x}
	done
	#cp cblas_list cblas.mylist
	#echo "cblas_xerbla" >> cblas.mylist
	#make ${IKERN} export=cblas.mylist name=libmkl_cblas

	if use fortran95; then
		local fc=${FORTRANC}
		if [ "${FORTRANC}" = "ifc" ]; then
			fc=ifort
		fi
		for x in blas lapack; do
			cd ${S}/${INSTDIR}/interfaces/${x}95
			make lib \
				PLAT=lnx${IARCH/em64t/32e} \
				FC=${fc} \
				INSTALL_DIR=${S}/${ILIBDIR}
		done
	fi
}

src_test() {

	local fc="gnu"
	if [ "${FORTRANC}" = "ifc" ]; then
		fc="ifort"
	fi

	cd ${S}/${INSTDIR}/tests
	for testdir in *; do
		einfo "Testing $testdir"
		cd ${testdir}
		emake so$IARCH F=${fc} || die "make $testdir failed"
	done
}

src_install () {
	cd ${S}

	# install license
	if  [ -n "${INTEL_LICENSE}" ] && \
		[ -f "${INTEL_LICENSE}" ]; then
		insinto /opt/intel/licenses
		doins ${INTEL_LICENSE}
	fi

	# install documentation and include files
	insinto /${INSTDIR}
	doins -r ${INSTDIR}/{doc,include}
	dodir /usr/include
	dosym /${INSTDIR}/include /usr/include/${PN}
	use examples && doins -r ${INSTDIR}/examples

	# install static libraries
	insinto /${ILIBDIR}
	doins ${ILIBDIR}/*.a
	dodir /usr/$(get_libdir)/{blas,lapack}/mkl
	dosym /${ILIBDIR}/libmkl_${IKERN}.a \
		/usr/$(get_libdir)/blas/mkl/libmkl_blas.a 
	dosym /${ILIBDIR}/libmkl_lapack.a \
		/usr/$(get_libdir)/lapack/mkl/libmkl_lapack.a 

	# install shared libraries
	insopts -m0755
	doins ${ILIBDIR}/*.so
	insinto /usr/$(get_libdir)/blas/mkl
	doins ${INSTDIR}/tools/builder/libmkl_{,c}blas.so
	insinto /usr/$(get_libdir)/lapack/mkl
	doins ${INSTDIR}/tools/builder/libmkl_lapack.so

	# install tools
	insopts -m0644
	insinto /${INSTDIR}
	rm -f ${INSTDIR}/tools/builder/*.so
	doins -r ${INSTDIR}/tools

	# install required configuration scripts
	insinto /usr/$(get_libdir)/blas	
	newins ${FILESDIR}/f77-MKL.blas f77-MKL
	newins ${FILESDIR}/c-MKL.blas c-MKL
	insinto /usr/$(get_libdir)/lapack
	newins ${FILESDIR}/f77-MKL.lapack f77-MKL
}

pkg_postinst() {

	${DESTTREE}/bin/blas-config MKL
	${DESTTREE}/bin/lapack-config MKL

	einfo
	einfo "MKL ${PV} is not yet available for eselect"
	einfo "Use blas-config and lapack-config to configure"
	einfo "blas or lapack with MKL"
	einfo 
}
