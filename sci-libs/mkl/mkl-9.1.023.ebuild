# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs fortran versionator

MYPV="$(get_major_version ${PV}).$(get_version_component_range 2 ${PV})"
MYP="${PN}-${MYPV}"

DESCRIPTION="Intel(R) Math Kernel Library: linear algebra, fft, random number generators."
HOMEPAGE="http://developer.intel.com/software/products/mkl/"
SRC_URI="l_${PN}_enh_p_${PV}.tgz"

LICENSE="${MYP}"

# slotting mechanism would need to select proper env-variables
# which could require a mkl-config like pkg.
#SLOT="${MYPV}"
SLOT="0"
RESTRICT="strip fetch"
KEYWORDS="~x86 ~amd64 ~ia64"
IUSE="threads int64 fortran95 fftw doc examples"

DEPEND="app-admin/eselect-blas
	app-admin/eselect-cblas
	app-admin/eselect-lapack"

RDEPEND="${DEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/blas-docs app-doc/lapack-docs )"

MKL_DIR=/opt/intel/${PN}/${MYPV}

pkg_nofetch() {
	einfo "Please download the intel mkl from:"
	einfo "http://www.intel.com/software/products/mkl/downloads/lin_mkl.htm"
	einfo "and place it in ${DISTDIR}"
	einfo "Also you need to register in ${HOMEPAGE}"
	einfo "and keep the license Intel sent you"
	einfo "SRC=${A}"
}

pkg_setup() {
	# setting up license
	[[ -z "${MKL_LICENSE}" ]] && MKL_LICENSE="$(find /opt/intel/licenses -name *MKL*.lic)"
	if  [[ -z "${MKL_LICENSE}" ]]; then
		eerror "Did not find any valid mkl license."
		eerror "Please locate your license file and run:"
		eerror "\t MKL_LICENSE=/my/license/dir emerge ${PN}"
		eerror "or place your license in /opt/intel/licenses"
		eerror "Hint: the license file is in the email Intel sent you"
		die "setup mkl license failed"
	fi

	# setting up compilers
	MKL_CC=gnu
	[[ "$(tc-getCC)" == "icc" ]] && MKL_CC=icc
	FORTRAN="gfortran ifc g77"
	use fortran95 && FORTRAN="gfortran ifc"
	use int64 && FORTRAN="gfortran ifc"
	fortran_pkg_setup
}

src_unpack() {

	ewarn
	ewarn "Intel ${PN} requires in average 400Mb of disk space"
	ewarn "Make sure you have them on ${PORTAGE_TMPDIR} and in /opt"
	ewarn
	unpack ${A}

	cd l_${PN}_*_${PV}/install

	# need to make a file to install non-interactively.
	# to produce such a file, first do it interactively
	# tar xf l_*; ./install.sh --duplicate mkl.ini;
	# the file will be instman/mkl.ini

	# binary blob extractor installs log crap in /opt/intel
	#addwrite /opt/intel
	cp ${MKL_LICENSE} ${WORKDIR}/
	MKL_LICENSE="$(basename ${MKL_LICENSE})"
	cat > mkl.ini << EOF
[MKL]
EULA_ACCEPT_REJECT=ACCEPT
FLEXLM_LICENSE_LOCATION=${WORKDIR}/${MKL_LICENSE}
INSTALLMODE=NONRPM
INSTALL_DESTINATION=${S}
EOF
	einfo "Extracting ..."
	./install \
		--silent ${PWD}/mkl.ini \
		--log log.txt &> /dev/null

	[[ -z $(find "${S}" -name libmkl.so) ]] \
		&& die "extracting failed"

	# remove unused stuff and set up intel names
	rm -rf "${WORKDIR}"/l_*
	case ${ARCH} in
		x86) MKL_ARCH=32
			MKL_KERN=ia32
			rm -rf "${S}"/lib*/*64*
			;;
		amd64) MKL_ARCH=em64t
			MKL_KERN=em64t
			rm -rf "${S}"/lib*/32 "${S}"/lib*/64
			;;
		ia64) MKL_ARCH=64
			MKL_KERN=ipf
			rm -rf "${S}"/lib*/32 "${S}"/lib*/em64t
			;;
	esac

	MKL_PROF="serial"

	if use threads; then
		MKL_PROF="${MKL_PROF} regular"
	else
		rm -rf "${S}"/lib
	fi

	if use int64; then
		MKL_PROF="${MKL_PROF} ilp64"
	else
		rm -rf "${S}"/lib_ilp64
	fi

	# fix a bad makefile in the test
	if [[ ${FORTRANC} == gfortran ]] || [[ ${FORTRANC} == if* ]]; then
		sed -i \
			-e "s/g77/${FORTRANC}/" \
			-e 's/-DGNU_USE//' \
			"${S}"/tests/fftf/makefile \
			|| die "sed fftf test failed"
	fi
}

src_compile() {

	if use fortran95; then
		for p in ${MKL_PROF}; do
			einfo "Compiling fortan95 wrappers for ${p}"
			for x in blas95 lapack95; do
				cd "${S}"/interfaces/${x}
				emake \
					FC=${FORTRANC} \
					MKL_SUBVERS=${p} \
					lib${MKL_ARCH} \
					|| die "emake $(basename ${x}) failed"
			done
		done
	fi

	if use fftw; then
		for p in ${MKL_PROF}; do
			einfo "Compiling fftw wrappers for ${p}"
			for x in "${S}"/interfaces/fft*; do
				cd "${x}"
				emake \
					F=${MKL_CC} \
					MKL_SUBVERS=${p} \
					lib${MKL_ARCH} \
					|| die "emake $(basename ${x}) failed"
			done
		done
	fi
}

src_test() {
	local usegnu
	[ ${FORTRANC} = g77 -o ${MKL_CC} = gnu ] && usegnu=gnu
	for testdir in blas cblas fftc fftf; do
		cd "${S}"/tests/${testdir}
		for p in ${MKL_PROF}; do
			einfo "Testing ${testdir} for ${p}"
			emake -j1 \
				F=${usegnu} \
				FC=${FORTRANC} \
				MKL_SUBVERS=${p} \
				lib${MKL_ARCH} \
				|| die "emake ${testdir} failed"
		done
	done
}

# usage: mkl_install_lib <serial|regular|ilp64>
mkl_install_lib() {

	local proflib=lib_${1}
	[[ "${1}" == "regular" ]] && proflib=lib
	local libdir="${MKL_DIR}/${proflib}/${MKL_ARCH}"
	local prof=${PN}
	local extlibs
	[[ "${FORTRANC}" == "gfortran" ]] && \
		extlibs="${extlibs} -L${libdir} -lmkl_gfortran"
	if [[ "${1}" == "regular" ]]; then
		extlibs="${extlibs} -L${libdir} -lguide -lpthread"
		prof=${prof}-threads
	fi
	[[ "${1}" == "ilp64" ]] && prof=${prof}-int64

	cp -pPR "${S}"/${proflib} "${D}"${MKL_DIR}

	for x in blas cblas; do
		cat  > eselect.${x}.${prof} << EOF
${libdir}/libmkl_${MKL_KERN}.a /usr/@LIBDIR@/lib${x}.a
${libdir}/libmkl.so /usr/@LIBDIR@/lib${x}.so
${libdir}/libmkl.so /usr/@LIBDIR@/lib${x}.so.0
${libdir}/${x}.pc /usr/@LIBDIR@/pkgconfig/${x}.pc
EOF

		[[ ${x} == cblas ]] && \
			echo "${MKL_DIR}/include/mkl_cblas.h /usr/include/cblas.h" >> eselect.${x}.${prof}
		eselect ${x} add $(get_libdir) eselect.${x}.${prof} ${prof}
		sed -e "s:@LIBDIR@:$(get_libdir):" \
			-e "s:@PV@:${PV}:" \
			-e "s:@EXTLIBS@:${extlibs}:g" \
			"${FILESDIR}"/${x}.pc.in > ${x}.pc || die "sed ${x}.pc failed"
		insinto ${libdir}
		doins ${x}.pc
	done

	cat > eselect.lapack.${prof} << EOF
${libdir}/libmkl_lapack.a /usr/@LIBDIR@/liblapack.a
${libdir}/libmkl_lapack.so /usr/@LIBDIR@/liblapack.so
${libdir}/libmkl_lapack.so /usr/@LIBDIR@/liblapack.so.0
${libdir}/lapack.pc /usr/@LIBDIR@/pkgconfig/lapack.pc
EOF
	sed -e "s:@LIBDIR@:$(get_libdir):" \
		-e "s:@PV@:${PV}:" \
		-e "s:@EXTLIBS@:${extlibs}:g" \
		"${FILESDIR}"/lapack.pc.in > lapack.pc || die "sed lapack.pc failed"
	insinto ${libdir}
	doins lapack.pc

	eselect lapack add $(get_libdir) eselect.lapack.${prof} ${prof}
	echo "LDPATH=${libdir}" > 35mkl
}

src_install() {

	# install license
	if  [ ! -f "/opt/intel/licenses/${MKL_LICENSE}" ]; then
		insinto /opt/intel/licenses
		doins ${WORKDIR}/${MKL_LICENSE}
	fi

	# keep intel dir in /opt as default install
	insinto ${MKL_DIR}
	doins -r include man tools || die "doins include|man|tools failed"

	use examples &&	doins -r examples

	insinto ${MKL_DIR}/doc
	doins doc/*.txt
	use doc && doins doc/*.pdf doc/*.htm

	# take care of lib and eselect files
	for p in ${MKL_PROF}; do
		mkl_install_lib ${p}
	done

	echo "MANPATH=${MKL_DIR}/man"  >> 35mkl
	echo "INCLUDE=${MKL_DIR}/include" >> 35mkl
	doenvd 35mkl || die "doenvd failed"
}

pkg_postinst() {
	# set default profile according to upstream
	local defprof="${PN}-${FORTRANC}"
	if use int64; then
		defprof="${defprof}-int64"
	elif use threads; then
		defprof="${defprof}-threads"
	fi

	for x in blas cblas lapack; do
		if [[ -z "$(eselect ${x} show)" ]]; then
			eselect ${x} set ${defprof}
		fi
	done
	# some useful info
	elog "Use 'eselect <lib>' (as root) to select one of the"
	elog "MKL <lib> profiles, where lib = blas, cblas or lapack"
	elog "Once selected, use 'pkg-config --libs <lib>' to link with MKL."
	elog "With C, add  'pkg-config --cflags <lib>' to compile."
}
