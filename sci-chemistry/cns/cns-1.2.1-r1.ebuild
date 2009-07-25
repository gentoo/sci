# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils fortran toolchain-funcs versionator flag-o-matic

MY_PN="${PN}_solve"
MY_PV="$(delete_version_separator 2)"
MY_P="${MY_PN}_${MY_PV}"

DESCRIPTION="Crystallography and NMR System"
HOMEPAGE="http://cns.csb.yale.edu/"
SRC_URI="${MY_P}_all-mp.tar.gz
	aria? ( aria2.2.tar.gz )"

SLOT="0"
LICENSE="cns"
KEYWORDS="~amd64 ~x86"
IUSE="aria openmp"

RDEPEND="app-shells/tcsh
	!app-text/dos2unix"
DEPEND="${RDEPEND}"
PDEPEND="aria? ( sci-chemistry/aria )"

RESTRICT="fetch"
S="${WORKDIR}/${MY_P}"

FORTRAN="g77 gfortran"

pkg_nofetch() {
	elog "Fill out the form at http://cns.csb.yale.edu/cns_request/"
	use aria && elog "and http://aria.pasteur.fr/"
	elog "and place these files:"
	elog ${A}
	elog "in ${DISTDIR}."
}

pkg_setup() {
	fortran_pkg_setup

	if [[ $(tc-getCC)$ == *gcc* ]] &&
		( [[ $(gcc-major-version)$(gcc-minor-version) -lt 42 ]] ||
		! built_with_use sys-devel/gcc openmp )
	then
		ewarn "You are using gcc and OpenMP is only available with gcc >= 4.2 "
		ewarn "Switch CC to an OpenMP capable compiler"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-gentoo.patch

	cd "${WORKDIR}"
	if use aria; then
		# Update the cns sources in aria for version 1.2.1
		epatch "${FILESDIR}"/1.2.1-aria.patch

		# Update the code with aria specific things
		cp -rf aria2.2/cns/src/* "${S}"/source/
	fi
	cd "${S}"

	append-fflags -fopenmp

	# the code uses Intel-compiler-specific directives
	epatch "${FILESDIR}"/${PV}-allow-gcc-openmp.patch

	OMPLIB="-lgomp"

	use amd64 && \
		append-cflags "-DINTEGER='long long int'" && \
		append-fflags -fdefault-integer-8

	# Set up location for the build directory
	# Uses obsolete `sort` syntax, so we set _POSIX2_VERSION
	cp "${FILESDIR}"/cns_solve_env_sh "${T}"/
	sed -i \
		-e "s:_CNSsolve_location_:${S}:g" \
		-e "17 s:\(.*\):\1\nsetenv _POSIX2_VERSION 199209:g" \
		"${S}"/cns_solve_env
	sed -i \
		-e "s:_CNSsolve_location_:${S}:g" \
		-e "17 s:\(.*\):\1\nexport _POSIX2_VERSION; _POSIX2_VERSION=199209:g" \
		"${T}"/cns_solve_env_sh
}

src_compile() {
	local GLOBALS
	local MALIGN
	if [[ ${FORTRANC} = g77 ]]; then
		GLOBALS="-fno-globals"
		MALIGN='\$(CNS_MALIGN_I86)'
	fi

	# Set up the compiler to use
	pushd instlib/machine/unsupported/g77-unix 2>/dev/null
	ln -s Makefile.header Makefile.header.${FORTRANC} || die
	popd 2>/dev/null

	# make install really means build, since it's expected to be used in-place
	emake \
		CC="$(tc-getCC)" \
		F77="${FORTRANC}" \
		LD="${FORTRANC}" \
		CCFLAGS="${CFLAGS} -DCNS_ARCH_TYPE_\$(CNS_ARCH_TYPE) \$(EXT_CCFLAGS)" \
		LDFLAGS="${LDFLAGS}" \
		F77OPT="${FFLAGS:- -O2} ${MALIGN}" \
		F77STD="${GLOBALS}" \
		OMPLIB="${OMPLIB}" \
		g77install \
		|| die "emake failed"

}

src_test() {
	# We need to force on g77 manually, because we can't get aliases working
	# when we source in a -c
	einfo "Running tests ..."
	sh -c \
		"export CNS_G77=ON; source ${T}/cns_solve_env_sh; make run_tests" \
		|| die "tests failed"
	einfo "Displaying test results ..."
	cat "${S}"/*_g77/test/*.diff-test
}

src_install() {
	# Install to locations resembling FHS
	sed -i \
		-e "s:${S}:usr:g" \
		-e "s:^\(setenv CNS_SOLVE.*\):\1\nsetenv CNS_ROOT /usr:g" \
		-e "s:^\(setenv CNS_SOLVE.*\):\1\nsetenv CNS_DATA \$CNS_ROOT/share/data:g" \
		-e "s:^\(setenv CNS_SOLVE.*\):\1\nsetenv CNS_DOC \$CNS_ROOT/share/doc/${PF}:g" \
		-e "s:CNS_LIB \$CNS_SOLVE/libraries:CNS_LIB \$CNS_DATA/libraries:g" \
		-e "s:CNS_MODULE \$CNS_SOLVE/modules:CNS_MODULE \$CNS_DATA/modules:g" \
		-e "s:CNS_HELPLIB \$CNS_SOLVE/helplib:CNS_HELPLIB \$CNS_DATA/helplib:g" \
		-e "s:\$CNS_SOLVE/bin/cns_info:\$CNS_DATA/cns_info:g" \
		"${S}"/cns_solve_env
	# I don't entirely understand why the sh version requires a leading /
	# for CNS_SOLVE and CNS_ROOT, but it does
	sed -i \
		-e "s:${S}:/usr:g" \
		-e "s:^\(^[[:space:]]*CNS_SOLVE=.*\):\1\nexport CNS_ROOT=/usr:g" \
		-e "s:^\(^[[:space:]]*CNS_SOLVE=.*\):\1\nexport CNS_DATA=\$CNS_ROOT/share/cns:g" \
		-e "s:^\(^[[:space:]]*CNS_SOLVE=.*\):\1\nexport CNS_DOC=\$CNS_ROOT/share/doc/${PF}:g" \
		-e "s:CNS_LIB=\$CNS_SOLVE/libraries:CNS_LIB=\$CNS_DATA/libraries:g" \
		-e "s:CNS_MODULE=\$CNS_SOLVE/modules:CNS_MODULE=\$CNS_DATA/modules:g" \
		-e "s:CNS_HELPLIB=\$CNS_SOLVE/helplib:CNS_HELPLIB=\$CNS_DATA/helplib:g" \
		-e "s:\$CNS_SOLVE/bin/cns_info:\$CNS_DATA/cns_info:g" \
		"${T}"/cns_solve_env_sh

	# Get rid of setup stuff we don't need in the installed script
	sed -i \
		-e "83,$ d" \
		-e "37,46 d" \
		"${S}"/cns_solve_env
	sed -i \
		-e "84,$ d" \
		-e "39,50 d" \
		"${T}"/cns_solve_env_sh

	newbin "${S}"/*_g77/bin/cns_solve* cns_solve \
		|| die "install cns_solve failed"

	# Can be run by either cns_solve or cns
	dosym cns_solve /usr/bin/cns

	# Don't want to install this
	rm -f "${S}"/*_g77/utils/Makefile

	dobin "${S}"/*_g77/utils/* || die "install utils failed"

	sed -i \
		-e "s:\$CNS_SOLVE/doc/:\$CNS_SOLVE/share/doc/${PF}/:g" \
		"${S}"/bin/cns_web

	dobin "${S}"/bin/cns_{edit,header,transfer,web} || die "install bin failed"

	insinto /usr/share/cns
	doins -r "${S}"/libraries "${S}"/modules "${S}"/helplib
	doins "${S}"/bin/cns_info

	insinto /etc/profile.d
	newins "${S}"/cns_solve_env cns_solve_env.csh
	newins "${T}"/cns_solve_env_sh cns_solve_env.sh

	dohtml \
		-A iq,cgi,csh,cv,def,fm,gif,hkl,inp,jpeg,lib,link,list,mask,mtf,param,pdb,pdf,pl,ps,sc,sca,sdb,seq,tbl,top \
		-f all_cns_info_template,omac,def \
		-r doc/html/*
}

pkg_info() {
		elog "Set OMP_NUM_THREADS to the number of threads you want."
		elog "If you get segfaults on large structures, set the GOMP_STACKSIZE"
		elog "variable if using gcc (16384 should be good)."
}

pkg_postinst() {
	pkg_info
}
