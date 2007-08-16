# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils fortran flag-o-matic toolchain-funcs

MY_PN="GotoBLAS"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="The fastest implementations of the Basic Linear Algebra Subroutines"
HOMEPAGE="http://www.tacc.utexas.edu/resources/software/software.php"
SRC_URI="http://www.tacc.utexas.edu/resources/software/login/gotoblas/${MY_P}.tar.gz"
LICENSE="tacc"
SLOT="0"
# See http://www.tacc.utexas.edu/resources/software/gotoblasfaq.php
# for supported architectures
KEYWORDS="~x86 ~amd64"
IUSE="threads doc"
RESTRICT="mirror"
RDEPEND="app-admin/eselect-blas
	dev-util/pkgconfig
	doc? ( app-doc/blas-docs )"

DEPEND="app-admin/eselect-blas
	>=sys-devel/binutils-2.17"

S="${WORKDIR}/${MY_PN}"
FORTRAN="g77 gfortran ifc"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Set up C compiler
	if [[ $(tc-getCC) = *gcc ]]; then
		C_COMPILER="GNU"
	elif [[ $(tc-getCC) = icc ]]; then
		C_COMPILER="INTEL"
	else
		die "tc-getCC() returned an invalid C compiler; valid are gcc or icc."
	fi

	# Set up FORTRAN 77 compiler
	case ${FORTRANC} in
		g77)
			F_COMPILER="G77"
			;;
		gfortran)
			F_COMPILER="GFORTRAN"
			F_LIB="-lgfortran"
			;;
		ifc|ifort)
			F_COMPILER="INTEL"
			;;
		*)
		die "fortran.eclass returned an invalid Fortran compiler \'${FORTRANC}\'; valid are ${FORTRAN}."
	esac

	# Fix shared lib build
	sed -i \
		-e "s:\(&& echo OK\):${F_LIB} \1:g" \
		"${S}"/exports/Makefile \
		|| die "sed for shared libs failed"

	# Set up compilers
	sed -i \
		-e "s:^# \(C_COMPILER =\) GNU:\1 ${C_COMPILER}:g" \
		-e "s:^# \(F_COMPILER =\) G77:\1 ${F_COMPILER}:g" \
		-e "s:^# \(SMP = 1\):\1:g" \
		-e "s:\$(COMPILER_PREFIX)ar:$(tc-getAR):" \
		-e "s:\$(COMPILER_PREFIX)as:$(tc-getAS):" \
		-e "s:\$(COMPILER_PREFIX)ld:$(tc-getLD):" \
		-e "s:\$(COMPILER_PREFIX)ranlib:$(tc-getRANLIB):" \
		"${S}"/Makefile.rule \
		|| die "sed for setting up compilers failed"

	# Threaded?
	if use threads; then
		sed -i \
			-e "s:^# \(SMP = 1\):\1:g" \
			"${S}"/Makefile.rule \
			|| die "sed for threads failed"
	fi

	# If you need a 64-bit integer interface, also do this for "INTERFACE64 = 1"
	if use amd64; then
		sed -i \
			-e "s:^# \(BINARY64  = 1\):\1:g" \
			"${S}"/Makefile.rule \
			|| die "sed for 64 binary failed"
	fi

	# Respect CFLAGS/FFLAGS
	sed -i \
		-e "/^COMMON_OPT += -O2$/d" \
		-e "s:^\(CFLAGS[[:space:]]*=\):\1 ${CFLAGS}:" \
		-e "s:^\(FFLAGS[[:space:]]*+=\):\1 ${FFLAGS}:" \
		"${S}"/Makefile.rule \
		|| die "sed for flags failed"
}

src_compile() {

	# Make static library
	emake LDFLAGS=$(raw-ldflags) || die "emake failed"

	# Make shared library
	cd exports
	emake so -j1 || die "emake failed"
}

src_test() {
	cd test
	emake || die "emake test failed"
	make clean
}

src_install() {
	local MAIN_DIR="/usr/$(get_libdir)/blas"
	local DIR="${MAIN_DIR}/goto"

	# dolib.so doesn't support our alternate locations
	exeinto ${DIR}
	doexe libgoto_*.so
	dosym libgoto_*.so ${DIR}/libgoto.so
	dosym libgoto_*.so ${DIR}/libgoto.so.0
	dosym libgoto_*.so ${DIR}/libgoto.so.0.0.0

	# dolib.a doesn't support our alternate locations
	insinto ${DIR}
	doins libgoto_*.a
	dosym libgoto_*.a ${DIR}/libgoto.a

	dodoc 01Readme.txt 03History.txt 04FAQ.txt

	cp "${FILESDIR}"/blas.pc.in blas.pc
	local extlibs=""
	use threads && extlibs="${extlibs} -lpthread"
	extlibs="${extlibs}"
	sed -i \
		-e "s/@LIBDIR@/$(get_libdir)/" \
		-e "s/@PV@/${PV}/" \
		-e "s/@EXTLIBS@/${extlibs}/" \
		blas.pc || die "sed blas.pc failed"
	insinto /usr/$(get_libdir)/blas/goto
	doins blas.pc
	eselect blas add $(get_libdir) "${FILESDIR}"/eselect.blas.goto goto
}

pkg_postinst() {
	[[ -z "$(eselect blas show)" ]] && eselect blas set goto
	elog "To use BLAS GOTO implementation, you have to issue (as root):"
	elog "\n\teselect blas set goto\n"
}
