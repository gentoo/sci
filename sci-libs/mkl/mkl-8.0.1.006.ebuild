# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit fortran rpm

MYPV=${PV/.006//}

DESCRIPTION="Intel(R) Math Kernel Library: linear algebra, fft, random number generators."
HOMEPAGE="http://developer.intel.com/software/products/mkl/"
SRC_URI="l_${PN}_p_${PV}.tgz"
RESTRICT="nostrip fetch"

#fortran95 implements a fortran 95 blas/lapack interface
IUSE="fortran95 examples"
SLOT="0"
LICENSE="mkl-8.0.1"
KEYWORDS="-* ~x86 ~amd64 ~ia64"
DEPEND="virtual/libc"
RDEPEND="${DEPEND}
    app-admin/eselect"

PROVIDE="virtual/blas
	     virtual/lapack"


S="${WORKDIR}/l_${PN}_p_${PV}"

pkg_setup() {
	if use fortran95; then
		FORTRAN="ifc gfortran"
		fortran_pkg_setup
	fi
}


# the whole shmol is to extract rpm files non-interactively
# from the big mkl installation
# hopefully recyclable for ipp
src_unpack() {

	if [ ! -n ${INTEL_LICENSE_FILES_TO_COPY} ]; then
		eerror "\$INTEL_LICENSE_FILES_TO_COPY undefined"
		eerror "Please locate your license file and run:"
		eerror "\t INTEL_LICENSE_FILES_TO_COPY=/my/license/files emerge ${PN}"
		eerror "or place your license in /opt/intel/license and run emerge ${PN}"
		die
	fi
	
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
	INSTDIR=/opt/intel/${PN}/${MYPV}

	cd ${S}/install
	# answer file to make the big install script non-interactive
	echo $"
[${PN}_install]
EULA_ACCEPT_REJECT=accept
FLEXLM_LICENSE_LOCATION=${INTEL_LICENSE_FILES_TO_COPY}
TEMP_DIR=${WORKDIR}/rpm
INSTALL_DESTINATION=${D}/opt
RPM_INSTALLATION=
" > answers.txt

	einfo "Building rpm file (be patient)..."
	./install \
		--noroot \
		--nonrpm \
		--installpath ${S}/opt \
		--silent answers.txt &> /dev/null

	rm -rf ${WORKDIR}/bin ${S}/*

	cd ${S}
	for x in $(ls ../rpm/*.rpm); do
		einfo "Extracting $(basename ${x})..."
		rpm_unpack ${x} || die "rpm_unpack failed"
	done
	mkdir opt/intel/licenses
	mv ../rpm/${PN}_license opt/intel/licenses/

	# clean up
	rm -rf ${WORKDIR}/rpm
    rm -rf ${S}${INSTDIR}/tools/environment	
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

	use ${ARCH} || rm -rf ${S}${INSTDIR}/lib/${IARCH}

	if use fortran95; then
		local fc=${FORTRANC}
		if [ "${FORTRANC}" = "ifc" ]; then
			fc=ifort
		fi
		for x in blas lapack; do
			cd ${S}${INSTDIR}/interfaces/${x}95
			make lib \
				PLAT=lnx${IARCH/em64t/32e} \
				FC=${fc} \
				INSTALL_DIR=${S}${INSTDIR}/lib/${IARCH}
		done
	fi

}

src_test() {

	local fc="gnu"
	if [ "${FORTRANC}" = "ifc" ]; then
		fc="ifort"
	fi

	cd ${S}${INSTDIR}/tests
	for testdir in *; do
		einfo "Testing $testdir"
		cd $testdir
		emake so$IARCH F=${fc} || die "make $testdir failed"
		rm -rf _results
	done
}

src_install () {

	# regular intel-style installation
	insinto ${INSTDIR}
	doins -r ./${INSTDIR}/{doc,include,tools}
	insinto ${INSTDIR}/lib/${IARCH}
	doins ./${INSTDIR}/lib/${IARCH}/*.a
	insopts -m0755
	doins ./${INSTDIR}/lib/${IARCH}/*.so
	insopts -m0644
	use examples && doins -r examples

	# gentoo-style installation
	dosym ${INSTDIR}/include /usr/include${PN}
	dodir /usr/$(get_libdir)/{blas,lapack}/{mkl,threaded-mkl}
	# TODO: stack the shared lib to one big one, rename proper libs

	# install the required configuration 
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
	einfo "Where <impl> is blas or lapack"
	einfo
}
