# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils toolchain-funcs versionator alternatives-2

LAPACKP=lapack-3.4.0

DESCRIPTION="Automatically Tuned Linear Algebra Software"
HOMEPAGE="http://math-atlas.sourceforge.net/"
SRC_URI="mirror://sourceforge/math-atlas/${PN}${PV}.tar.bz2
	fortran? ( lapack? ( http://www.netlib.org/lapack/${LAPACKP}.tgz ) )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="fortran doc lapack static-libs threads"

RDEPEND="fortran? ( virtual/fortran )"
DEPEND="${RDEPEND}
	!prefix? ( sys-power/cpufrequtils )"

S="${WORKDIR}/ATLAS"

atlas_configure() {
	# hack needed to trick the flaky gcc detection
	local mycc="$(tc-getCC)"
	[[ ${mycc} == *gcc* ]] && mycc=gcc

	local myconf=(
		"--prefix=${ED}/usr"
		"--libdir=${ED}/usr/$(get_libdir)"
		"--incdir=${ED}/usr/include"
		"--cc=${mycc}"
		"-C ac ${mycc}"
		"-D c -DWALL"
		"-F ac '${CFLAGS}'"
		"-Ss pmake '\$(MAKE) ${MAKEOPTS}'"
	)

	# OpenMP shown to decreased performance over POSIX threads
	# (at least in 3.9.x, see atlas-dev mailing list)
	if use threads; then
		myconf+=( "-t -1" "-Si omp 0" )
	else
		myconf+=( "-t  0" "-Si omp 0" )
	fi

	if use amd64 || use ppc64 || use sparc; then
		if [ ${ABI} = amd64 ] || [ ${ABI} = ppc64 ] || [ ${ABI} = sparc64 ] ; then
			myconf+=( "-b 64" )
		elif [ ${ABI} = x86 ] || [ ${ABI} = ppc ] || [ ${ABI} = sparc32 ] ; then
			myconf+=( "-b 32" )
		else
			myconf+=( "-b 64" )
		fi
	elif use ppc || use x86; then
		myconf+=( "-b 32" )
	elif use ia64; then
		myconf+=( "-b 64" )
	else #hppa alpha ...
		myconf+=( "" )
	fi
	if use fortran; then
		myconf+=(
			"-C if $(tc-getFC)"
			"-F if '${FFLAGS}'"
		)
		if use lapack; then
			myconf+=(
				"-Si latune 1"
				"--with-netlib-lapack-tarfile=${DISTDIR}/${LAPACKP}.tgz"
			)
		else
			myconf+=( "-Si latune 0" )
		fi
	else
		myconf+=( "-Si latune 0" "--nof77" )
	fi
	local confdir="${S}_${1}"; shift
	myconf+=( $@ )
	mkdir "${confdir}" && cd "${confdir}"
	# for debugging
	echo ${myconf[@]} > myconf.out
	"${S}"/configure ${myconf[@]} || die "configure in ${confdir} failed"
}

atlas_compile() {
	pushd "${S}_${1}" > /dev/null
	# atlas does its own parallel builds
	emake -j1 build
	cd lib
	emake libclapack.a
	[[ -e libptcblas.a ]] && emake libptclapack.a
	popd > /dev/null
}

# transform a static archive into a shared library and install them
# atlas_install_libs <mylib.a> [extra link flags]
atlas_install_libs() {
	local libname=$(basename ${1%.*})
	einfo "Installing ${libname}"
	local soname=${libname}.so.$(get_major_version)
	shift
	pushd "${S}_shared"/lib > /dev/null
	${LINK:-$(tc-getCC)} ${LDFLAGS} -shared -Wl,-soname=${soname} \
		-Wl,--whole-archive ${libname}.a -Wl,--no-whole-archive \
		"$@" -o ${soname} || die "Creating ${soname} failed"
	dolib.so ${soname}
	ln -s ${soname} ${soname%.*}
	dosym ${soname} /usr/$(get_libdir)/${soname%.*}
	popd > /dev/null
	use static-libs && dolib.a "${S}_static"/lib/${libname}.a
}

# create and install a pkgconfig file
# atlas_install_pc <libname> <pkg name> [extra link flags]
atlas_install_pc() {
	local libname=${1} ; shift
	local pcname=${1} ; shift
	cat <<-EOF > ${pcname}.pc
		prefix=${EPREFIX}/usr
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include
		Name: ${pcname}
		Description: ${PN} ${pcname}
		Version: ${PV}
		URL: ${HOMEPAGE}
		Libs: -L\${libdir} -l${libname} $@
		Cflags: -I\${includedir}/${PN}
		${PCREQ}
	EOF
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${pcname}.pc
}

pkg_setup() {
	if [[ -n $(type -P cpufreq-info) ]]; then
		[[ -z $(cpufreq-info -d) ]] && return
		local ncpu=$(LANG=C cpufreq-info | grep -c "analyzing CPU")
		local cpu=0
		while [[ ${cpu} -lt ${ncpu} ]]; do
			if ! $(LANG=C cpufreq-info -p -c ${cpu} | grep -q performance); then
				ewarn "CPU $cpu is not set to performance"
				ewarn "Run cpufreq-set -r -g performance as root"
				die "${PN} needs all cpu set to performance"
			fi
			cpu=$(( cpu + 1 ))
		done
	else
		ewarn "Please make sure to disable CPU throttling completely"
		ewarn "during the compile of ${PN}. Otherwise, all ${PN}"
		ewarn "generated timings will be completely random and the"
		ewarn "performance of the resulting libraries will be degraded"
		ewarn "considerably."
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/3.9.39-bfr-overflow.patch
	epatch "${FILESDIR}"/3.9.63-leaks.patch
}

src_configure() {
	atlas_configure shared "-Fa alg -fPIC"
	use static-libs && atlas_configure static
}

src_compile() {
	atlas_compile shared
	use static-libs && atlas_compile static
}

src_test() {
	cd "${S}_shared"
	emake -j1 check
	emake -j1 time
}

src_install() {
	cd "${S}_shared/lib"
	# rename to avoid collision with other packages
	local l
	for l in {,c}{blas,lapack}; do
		if [[ -e lib${l}.a ]]; then
			mv lib{,atl}${l}.a
			use static-libs && mv "${S}"_static/lib/lib{,atl}${l}.a
		fi
	done

	[[ -e libptcblas.a ]] && PTLIBS="-lpthread"

	# atlas
	atlas_install_libs libatlas.a -lm ${PTLIBS}

	# cblas
	atlas_install_libs libatlcblas.a -lm -L. -latlas
	atlas_install_pc atlcblas atlas-cblas -lm -latlas
	alternatives_for cblas atlas 0 \
		/usr/$(get_libdir)/pkgconfig/cblas.pc atlas-cblas.pc \
		/usr/include/cblas.h atlas/cblas.h

	# cblas threaded
	if [[ -e libptcblas.a ]]; then
		atlas_install_libs libptcblas.a -lm -L. -latlas ${PTLIBS}
		atlas_install_pc ptcblas atlas-cblas-threads -lm -latlas ${PTLIBS}
		alternatives_for cblas atlas-threads 0 \
			/usr/$(get_libdir)/pkgconfig/cblas.pc atlas-cblas-threads.pc \
			/usr/include/cblas.h atlas/cblas.h
	fi

	if use lapack; then
		PCREQ="Requires: cblas"
		# clapack
		atlas_install_libs libatlclapack.a -lm -L. -latlas -latlcblas
		atlas_install_pc atlclapack atlas-clapack -lm -latlas

		# clapack threaded
		if [[ -e libptclapack.a ]]; then
			atlas_install_libs libptclapack.a -lm -L. -latlas -lptcblas ${PTLIBS}
			atlas_install_pc ptclapack atlas-clapack-threads -lm -latlas ${PTLIBS}
		fi
	fi

	if use fortran; then
		LINK=$(tc-getF77) PCREQ=
		# blas
		atlas_install_libs libf77blas.a -lm -L. -latlas
		atlas_install_pc f77blas atlas-blas -lm -latlas
		alternatives_for blas atlas 0 \
			/usr/$(get_libdir)/pkgconfig/blas.pc atlas-blas.pc

		# blas threaded
		if [[ -e libptf77blas.a ]]; then
			atlas_install_libs libptf77blas.a -lm -L. -latlas ${PTLIBS}
			atlas_install_pc ptf77blas atlas-blas-threads -lm -latlas ${PTLIBS}
			alternatives_for blas atlas-threads 0 \
				/usr/$(get_libdir)/pkgconfig/blas.pc atlas-blas-threads.pc
		fi

		if use lapack; then
			PCREQ="Requires: blas cblas"
			# lapack
			atlas_install_libs libatllapack.a \
				-lm -L. -latlas -latlcblas -lf77blas
			atlas_install_pc atllapack atlas-lapack -lm -latlas
			alternatives_for lapack atlas 0 \
				/usr/$(get_libdir)/pkgconfig/lapack.pc atlas-lapack.pc
			# lapack threaded
			if [[ -e libptlapack.a ]]; then
				atlas_install_libs libptlapack.a \
					-lm -L. -latlas -lptcblas -lptf77blas ${PTLIBS}
				atlas_install_pc ptlapack atlas-lapack-threads \
					-lm -latlas ${PTLIBS}
				alternatives_for lapack atlas-threads 0 \
					/usr/$(get_libdir)/pkgconfig/lapack.pc atlas-lapack-threads.pc
			fi
		fi
	fi

	cd "${S}"
	insinto /usr/include/${PN}
	doins include/*.h

	cd "${S}/doc"
	dodoc INDEX.txt AtlasCredits.txt ChangeLog
	use doc && dodoc atlas*pdf cblas.pdf cblasqref.pdf
	use doc && use fortran && dodoc f77blas*pdf
	use doc && use fortran && use lapack && dodoc lapack*pdf
}
