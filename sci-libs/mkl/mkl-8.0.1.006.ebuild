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
DEPEND="virtual/libc"
RDEPEND="${DEPEND}
    app-admin/eselect"

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
			ICPU="def"
			(is-flag '-march=k8' || 
				is-flag '-march=nocona' ) && ICPU="p4n"
			;;
		ia64)
			IARCH="64"
			IKERN="ipf"
			ICPU="i2p"
			;;
		x86)
			IARCH="32"
			IKERN="ia32"
			ICPU="def"
			# could work out better cpu detection. now works for gcc-3.4 and icc
			( is-flag '-march=pentium3' || \
				is-flag '-march=pentiumiii') && ICPU="p3"
			( is-flag '-march=pentium4' || \
				is-flag '-msse2') && ICPU="p4"
			is-flag '-msse3' && ICPU="p4e"
			;;
	esac
	ILIBDIR=${INSTDIR}/lib/${IARCH}
	einfo "IARCH=$IARCH IKERN=$IKERN ICPU=$ICPU"

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
	# regular intel-style installation
	if  [ -n "${INTEL_LICENSE}" ] && \
		[ -f "${INTEL_LICENSE}" ]; then
		insinto /opt/intel/licenses
		doins ${INTEL_LICENSE}
	fi
	insinto /${INSTDIR}
	doins -r ${INSTDIR}/{doc,include,tools}
	use examples && doins -r ${INSTDIR}/examples
	insinto /${ILIBDIR}
	doins ${ILIBDIR}/*.a
	insopts -m0755
	doins ${ILIBDIR}/*.so
	insopts -m0644

	# gentoo-style installation
	dodir /usr/include
	dosym /${INSTDIR}/include /usr/include/${PN}

	dodir /usr/$(get_libdir)/{blas,lapack}/{mkl,threaded-mkl}

	# All install stuff below needs work using nasty libtool
	# ---------------------------------------------------

	insopts -m0755
	gcc -fPIC -shared -L${S}/${ILIBDIR} -lmkl -lmkl_${ICPU} \
		-o libmkl_blas.so
	insinto /usr/$(get_libdir)/blas/mkl
	doins libmkl_blas.so

	gcc -fPIC -shared -L${S}/${ILIBDIR} -lmkl_lapack32 -lmkl_lapack64 \
		-o libmkl_lapack.so 
	insinto /usr/$(get_libdir)/lapack/mkl
	doins libmkl_lapack.so

	gcc -fPIC -shared -L${S}/${ILIBDIR} -lmkl -lmkl_${ICPU} -lguide \
		-o libmkl_blas.so
	insinto /usr/$(get_libdir)/blas/threaded-mkl
	doins libmkl_blas.so

	gcc -fPIC -shared -L${S}/${ILIBDIR} -lmkl_lapack32 -lmkl_lapack64 -lguide \
		-o libmkl_lapack.so
	insinto /usr/$(get_libdir)/lapack/threaded-mkl
	doins libmkl_lapack.so
	
	insopts -m0644
	ar cr libmkl_blas.a ${ILIBDIR}/lib{mkl_${IKERN},guide}.a
	ranlib libmkl_blas.a
	insinto /usr/$(get_libdir)/blas/threaded-mkl
	doins libmkl_blas.a

	ar cr libmkl_lapack.a ${ILIBDIR}/lib{mkl_lapack,guide}.a
	ranlib libmkl_lapack.a	
	insinto /usr/$(get_libdir)/lapack/threaded-mkl
	doins libmkl_lapack.a
	# ---------------------------------------------------

	dosym /${ILIBDIR}/libmkl_${IKERN}.a \
		/usr/$(get_libdir)/blas/mkl/libmkl_blas.a 
	dosym /${ILIBDIR}/libmkl_lapack.a \
		/usr/$(get_libdir)/lapack/mkl/libmkl_lapack.a 

	# install the required configuration scripts
	for x in blas lapack; do
		insinto /usr/$(get_libdir)/${x}		
		for y in f77 f77-threaded c c-threaded; do
			newins ${FILESDIR}/${y}-MKL.${x} ${y}-MKL
		done
	done
}

pkg_postinst() {

	einfo
	einfo "To use MKL's linear algebra, features, you have to issue (as root):"
	einfo "\t eselect <impl> set MKL"
	einfo "where <impl> is blas or lapack"
	einfo
}
