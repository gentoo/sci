# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MYPV=${PV/.006//}

DESCRIPTION="Intel(R) Math Kernel Library: linear algebra, fft, random number generators."
HOMEPAGE="http://developer.intel.com/software/products/mkl/"
SRC_URI="l_${PN}_p_${PV}.tgz"
RESTRICT="nostrip fetch"
IUSE=""
SLOT="0"
LICENSE="mkl-8.0"
KEYWORDS="-* ~x86 ~amd64 ~ia64"
DEPEND="virtual/libc
    app-arch/rpm2targz"
RDEPEND="virtual/libc
    app-admin/eselect"
PROVIDE="virtual/blas
	     virtual/lapack"
# should it provide fft as well?


S="${WORKDIR}/l_${PN}_p_${PV}"

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

	# we cannot sed on such a big binary install file, so we trick it
	# fake rpm commands to exit the nasty install once done building the rpm
	# anyway, might just a dependence to rpm after all

	mkdir -p bin
	echo "exit 1" > bin/rpm2cpio
	echo "exit 1" > bin/rpm
	chmod +x bin/*
	export PATH=".:${PATH}:$PWD/bin"
	export INSTDIR=/opt/intel/${PN}/${MYPV}

	cd ${S}/install
	# create an answer file to the install program
	echo $"
[${PN}_install]
EULA_ACCEPT_REJECT=accept
FLEXLM_LICENSE_LOCATION=${INTEL_LICENSE_FILES_TO_COPY}
TEMP_DIR=${WORKDIR}/rpm
INSTALL_DESTINATION=${D}/opt
RPM_INSTALLATION=
" > answers.txt

	einfo "Building rpm file (be patient)..."
	./install --noroot --nonrpm --installpath ${S}/opt --silent answers.txt &> /dev/null 
	rm -rf ${WORKDIR}/bin ${S}/*

	cd ${WORKDIR}/rpm
	for x in *.rpm; do
		einfo "Extracting ${x}..."
		rpm2targz ${x} || die "rpm2targz failed"
		tar xfz ${x/.rpm/.tar.gz} -C ${S}
		rm -f ${x} ${x/.rpm/.tar.gz}
	done
	mkdir ${S}/opt/intel/licenses
	cp ${PN}_license ${S}/opt/intel/licenses/
	cd ${WORKDIR}
	rm -rf rpm
	case ${ARCH} in
		amd64)
			IARCH="em64t"
			;;
		ia64)
			IARCH="64"
			;;
		x86)
			IARCH="32"
			;;
	esac
	export IARCH
	# remove unnecessary stuff
	use ${ARCH} || rm -rf ${S}${INSTDIR}/lib/${IARCH}
	rm -rf ${S}${INSTDIR}/tools/environment
	
}

src_compile() {
	einfo "Nothing to compile"
}


src_test() {
	# todo: testing with compilers and flags other than gcc/g77
	cd ${S}${INSTDIR}/tests
	for testdir in *; do
		einfo "Testing $testdir"
		cd $testdir
		emake so$IARCH F=gnu || die "make $testdir failed"
	done
}

src_install () {
	#does not work
	#cp -pPR * ${D}

	cd ${S}${INSTDIR}
	insinto ${INSTDIR}
	# should we keep the tests dir? if yes, remove test results
	doins -r doc examples include interfaces tools

	insinto ${INSTDIR}/lib/${IARCH}
	doins lib/${IARCH}/*.a
	insopts -m0755
	doins lib/${IARCH}/*.so

	#todo: make it work with eselect/blas-config/lapack-config

	echo "INCLUDE=${INSTDIR}/include:\${INCLUDE}" > 35mkl
	echo "LD_LIBRARY_PATH=${INSTDIR}/lib/${IARCH}:\${LD_LIBRARY_PATH}" >> 35mkl
	doenvd 35mkl
}

pkg_postinst() {
	einfo
	einfo "To use MKL's BLAS features, you have to issue (as root):"
	einfo "\n\teselect blas set MKL"
	einfo "To use MKL's LAPACK features, you have to issue (as root):"
	einfo "\n\teselect lapack set MKL"
	einfo
}
