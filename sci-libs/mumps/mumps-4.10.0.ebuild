# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils toolchain-funcs flag-o-matic versionator fortran-2

MYP=MUMPS_${PV}

DESCRIPTION="MUltifrontal Massively Parallel sparse direct matrix Solver"
HOMEPAGE="http://mumps.enseeiht.fr/"
SRC_URI="${HOMEPAGE}${MYP}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples metis mpi +scotch static-libs"

RDEPEND="virtual/blas
	metis? ( || ( sci-libs/metis <sci-libs/parmetis-4 )
		mpi? ( <sci-libs/parmetis-4 ) )
	scotch? ( sci-libs/scotch[mpi=] )
	mpi? ( virtual/scalapack )"

DEPEND="${RDEPEND}
	virtual/fortran
	virtual/pkgconfig"

S="${WORKDIR}/${MYP}"

make_shared_lib() {
	local libstatic=${1}
	if [[ ${CHOST} == *-darwin* ]] ; then
		local dylibname=$(basename "${1%.a}").dylib
		shift
		einfo "Making ${dylibname}"
		${LINK:-$(tc-getCC)} ${LDFLAGS}  \
			-dynamiclib -install_name "${EPREFIX}"/usr/lib/"${dylibname}" \
			-Wl,-all_load -Wl,"${libstatic}" \
			"$@" -o $(dirname "${libstatic}")/"${dylibname}" || die
	else
		local soname=$(basename "${1%.a}").so.${LIBVER}
		shift
		einfo "Making ${soname}"
		${LINK:-$(tc-getCC)} ${LDFLAGS}  \
			-shared -Wl,-soname="${soname}" \
			-Wl,--whole-archive "${libstatic}" -Wl,--no-whole-archive \
			"$@" -o $(dirname "${libstatic}")/"${soname}" || die "${soname} failed"
		ln -s "${soname}" $(dirname "${libstatic}")/"${soname%.*}"
	fi
}

src_prepare() {
	sed -e "s:^\(CC\s*=\).*:\1$(tc-getCC):" \
		-e "s:^\(FC\s*=\).*:\1$(tc-getFC):" \
		-e "s:^\(FL\s*=\).*:\1$(tc-getFC):" \
		-e "s:^\(AR\s*=\).*:\1$(tc-getAR) rv :" \
		-e "s:^\(RANLIB\s*=\).*:\1$(tc-getRANLIB):" \
		-e "s:^\(LIBBLAS\s*=\).*:\1$(pkg-config --libs blas):" \
		-e "s:^\(INCPAR\s*=\).*:\1:" \
		-e 's:^\(LIBPAR\s*=\).*:\1$(SCALAP):' \
		-e "s:^\(OPTF\s*=\).*:\1${FFLAGS} -DALLOW_NON_INIT \$(PIC):" \
		-e "s:^\(OPTC\s*=\).*:\1${CFLAGS} \$(PIC):" \
		-e "s:^\(OPTL\s*=\).*:\1${LDFLAGS}:" \
		Make.inc/Makefile.inc.generic > Makefile.inc || die
	# fixed a missing copy of libseq to libdir

}

src_configure() {
	LIBADD="$(pkg-config --libs blas) -Llib -lpord"
	local ord="-Dpord"
	if use metis && use mpi; then
		sed -i \
			-e "s:#\s*\(LMETIS\s*=\).*:\1$(pkg-config --libs parmetis):" \
			-e "s:#\s*\(IMETIS\s*=\).*:\1$(pkg-config --cflags parmetis):" \
			Makefile.inc || die
		LIBADD="${LIBADD} $(pkg-config --libs parmetis)"
		ord="${ord} -Dparmetis"
	elif use metis; then
		sed -i \
			-e "s:#\s*\(LMETIS\s*=\).*:\1$(pkg-config --libs metis):" \
			-e "s:#\s*\(IMETIS\s*=\).*:\1$(pkg-config --cflags metis):" \
			Makefile.inc || die
		LIBADD="${LIBADD} $(pkg-config --libs metis)"
		ord="${ord} -Dmetis"
	fi
	if use scotch && use mpi; then
		sed -i \
			-e "s:#\s*\(LSCOTCH\s*=\).*:\1-lptesmumps -lptscotch -lptscotcherr:" \
			-e "s:#\s*\(ISCOTCH\s*=\).*:\1-I${EROOT}usr/include/scotch:" \
			Makefile.inc || die
		LIBADD="${LIBADD} -lptesmumps -lptscotch -lptscotcherr"
		ord="${ord} -Dptscotch"
	elif use scotch; then
		sed -i \
			-e "s:#\s*\(LSCOTCH\s*=\).*:\1-lesmumps -lscotch -lscotcherr:" \
			-e "s:#\s*\(ISCOTCH\s*=\).*:\1-I${EROOT}usr/include/scotch:" \
			Makefile.inc || die
		LIBADD="${LIBADD} -lesmumps -lscotch -lscotcherr"
		ord="${ord} -Dscotch"
	fi
	if use mpi; then
		sed -i \
			-e "s:^\(CC\s*=\).*:\1mpicc:" \
			-e "s:^\(FC\s*=\).*:\1mpif90:" \
			-e "s:^\(FL\s*=\).*:\1mpif90:" \
			-e "s:^\(SCALAP\s*=\).*:\1$(pkg-config --libs scalapack):" \
			Makefile.inc || die
		export LINK=mpif90
		LIBADD="${LIBADD} $(pkg-config --libs scalapack)"
	else
		sed -i \
			-e 's:-Llibseq:-L$(topdir)/libseq:' \
			-e 's:PAR):SEQ):g' \
			-e 's:^LIBSEQNEEDED =:LIBSEQNEEDED = libseqneeded:g' \
			Makefile.inc || die
	fi
	sed -i -e "s:^\s*\(ORDERINGSF\s*=\).*:\1 ${ord}:" Makefile.inc || die
}

src_compile() {
	emake alllib PIC="-fPIC"
	make_shared_lib lib/libmumps_common.a ${LIBADD}
	local i
	for i in c d s z; do
		make_shared_lib lib/lib${i}mumps.a -Llib -lmumps_common
	done
	if use static-libs; then
		emake clean
		emake alllib
	fi
}

src_test() {
	emake all
	local dotest
	use mpi && dotest="mpirun -np 2"
	cd examples
	${dotest} ./ssimpletest < input_simpletest_real || die
	${dotest} ./dsimpletest < input_simpletest_real || die
	${dotest} ./csimpletest < input_simpletest_cmplx || die
	${dotest} ./zsimpletest < input_simpletest_cmplx || die
	einfo "The solutions should be close to (1,2,3,4,5)"
	${dotest} ./c_example || die
	einfo "The solution should be close to (1,2)"
	make clean
}

src_install() {
	dolib.so lib/lib*$(get_libname)*
	use static-libs && dolib.a lib/lib*.a
	insinto /usr
	doins -r include
	dodoc README ChangeLog VERSION
	use doc && dodoc doc/*.pdf
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
