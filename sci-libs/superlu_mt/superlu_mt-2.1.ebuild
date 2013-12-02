# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/superlu/superlu-4.3.ebuild,v 1.7 2012/12/12 20:31:31 jlec Exp $

EAPI=5

inherit eutils fortran-2 toolchain-funcs

MYPN=SuperLU_MT

DESCRIPTION="Multithreaded sparse LU factorization library"
HOMEPAGE="http://crd.lbl.gov/~xiaoye/SuperLU/"
SRC_URI="${HOMEPAGE}/${PN}_${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc openmp threads examples static-libs test"

RDEPEND="
	virtual/blas"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( app-shells/tcsh )"

S="${WORKDIR}/${MYPN}_${PV}"

pkg_setup() {
	if use threads; then
		export CTHREADS="-D__PTHREAD" LDTHREADS="-pthread"
	elif use openmp; then
		if [[ $(tc-getCC) == *gcc ]] && ! tc-has-openmp; then
			ewarn "OpenMP is not available in your current selected gcc"
			die "need openmp capable gcc"
		fi
		FORTRAN_NEED_OPENMP=1
		export CTHREADS="-D__OPENMP"
		[[ $(tc-getCC) == *gcc ]] && LDTHREADS="-fopenmp"
	else
		ewarn "Neither threads or openmp selected. Forcing threads"
		export CTHREADS="-D__PTHREAD" LDTHREADS="-pthread"
	fi
	fortran-2_pkg_setup
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-duplicate-symbols.patch \
		"${FILESDIR}"/${P}-missing-includes.patch
}

src_configure() {
	sed -i \
		-e 's/^\(PLAT\s*=\).*/\1/' \
		-e "s:^\(CC\s*=\).*:\1 $(tc-getCC):" \
		-e "/CFLAGS/s:-O3:${CFLAGS} \$(PIC):" \
		-e "s:^\(PREDEFS\s*=\).*:\1 ${CPPFLAGS} -DUSE_VENDOR_BLAS \$(CTHREADS)$:" \
		-e "s:^\(NOOPTS\s*=.*\):\1 \$(PIC):" \
		-e "s:^\(FORTRAN\s*=\).*:\1 $(tc-getFC):" \
		-e "s:^\(FFLAGS\s*=\).*:\1 ${FFLAGS} \$(PIC):" \
		-e "s:^\(ARCH\s*=\).*:\1 $(tc-getAR):" \
		-e "s:^\(RANLIB\s*=\).*:\1 $(tc-getRANLIB):" \
		-e "s:^\(LOADER\s*=\).*:\1 $(tc-getCC):" \
		-e "s:^\(LOADOPTS\s*=\).*:\1 ${LDFLAGS} \$(LDTHREADS):" \
		-e "/MPLIB/d" \
		-e "s:^\(BLASLIB\s*=\).*:\1 $($(tc-getPKG_CONFIG) --libs blas):" \
		make.inc || die
	SONAME=libsuperlu_mt.so.0
	sed -i \
		-e 's|../make.inc|make.inc|' \
		-e "s|../SRC|${EPREFIX}/usr/include/${PN}|" \
		-e '/:.*$(SUPERLULIB)/s|../lib/$(SUPERLULIB)||g' \
		-e 's|../lib/$(SUPERLULIB)|-lsuperlu_mt|g' \
		EXAMPLE/Makefile || die
}

src_compile() {
	emake superlulib \
		PIC="-fPIC" ARCH="echo" ARCHFLAGS="" RANLIB="echo"
	$(tc-getCC) ${LDFLAGS} ${LDTHREADS} -shared -Wl,-soname=${SONAME} SRC/*.o \
		$($(tc-getPKG_CONFIG) --libs blas) -lm -o lib/${SONAME} || die
	ln -s ${SONAME} lib/libsuperlu_mt.so || die

	use static-libs && rm -f SRC/*.o &&	emake superlulib \
		PIC="" ARCH="$(tc-getAR)" ARCHFLAGS="cr" RANLIB="$(tc-getRANLIB)"
}

src_test() {
	emake -j1 tmglib
	LD_LIBRARY_PATH="${S}/lib:${LD_LIBRARY_PATH}" \
		emake SUPERLULIB="${SONAME}" testing
}

src_install() {
	dolib.so lib/*so*
	use static-libs && dolib.a lib/*.a
	insinto /usr/include/${PN}
	doins SRC/*h
	dodoc README
	use doc && dodoc DOC/ug.pdf
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r EXAMPLE/* make.inc
	fi
}

pkg_postinst() {
	elog "${PN} has been designed to work with a single-threaded blas library"
	elog "Make sure to eselect one (openblas/atlas) when using superlu_mt"
}
