# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/superlu/superlu-4.3.ebuild,v 1.7 2012/12/12 20:31:31 jlec Exp $

EAPI=5

inherit eutils toolchain-funcs

MYPN=SuperLU_DIST

DESCRIPTION="MPI distributed sparse LU factorization library"
HOMEPAGE="http://crd.lbl.gov/~xiaoye/SuperLU/"
SRC_URI="${HOMEPAGE}/${PN}_${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs"

RDEPEND="
	sci-libs/parmetis
	virtual/mpi"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MYPN}_${PV}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-duplicate-symbols.patch
}

src_configure() {
	sed -i \
		-e 's/^\(PLAT\s*=\).*/\1/' \
		-e "s:^\(CC\s*=\).*:\1 mpicc:" \
		-e "/CFLAGS/s:-fast -Mipa=fast,safe:${CFLAGS} \$(PIC):" \
		-e "s:^\(PREDEFS\s*=\).*:\1 ${CPPFLAGS} -DUSE_VENDOR_BLAS \$(CTHREADS)$:" \
		-e "s:^\(NOOPTS\s*=.*\):\1 \$(PIC):" \
		-e "s:^\(FORTRAN\s*=\).*:\1 mpif77:" \
		-e "s:^\(F90FLAGS\s*=\).*:\1 ${FFLAGS} \$(PIC):" \
		-e "s:^\(ARCH\s*=\).*:\1 $(tc-getAR):" \
		-e "s:^\(RANLIB\s*=\).*:\1 $(tc-getRANLIB):" \
		-e "s:^\(LOADER\s*=\).*:\1 mpicc:" \
		-e "s:^\(LOADOPTS\s*=\).*:\1 ${LDFLAGS} \$(LDTHREADS):" \
		-e '/^FLIBS/d' \
		-e "s:^\(METISLIB\s*=\).*:\1 -lmetis:" \
		-e "s:^\(PARMETISLIB\s*=\).*:\1 -lparmetis:" \
		-e "s:^\(BLASLIB\s*=\).*:\1 $($(tc-getPKG_CONFIG) --libs blas):" \
		-e "s:^\(DSUPERLULIB\s*=\).*:\1 ../lib/libsuperlu_dist.a:" \
		make.inc || die
	SONAME=libsuperlu_dist.so.0
	sed -i \
		-e 's|../make.inc|make.inc|' \
		-e "s|../SRC|${EPREFIX}/usr/include/${PN}|" \
		-e '/:.*$(DSUPERLULIB)/s|../lib/$(DSUPERLULIB)||g' \
		-e 's|../lib/$(DSUPERLULIB)|-lsuperlu_dist|g' \
		EXAMPLE/Makefile || die
}

src_compile() {
	emake superlulib \
		PIC="-fPIC" ARCH="echo" ARCHFLAGS="" RANLIB="echo"
	$(tc-getCC) ${LDFLAGS} ${LDTHREADS} -shared -Wl,-soname=${SONAME} SRC/*.o \
		$($(tc-getPKG_CONFIG) --libs blas) -lm -o lib/${SONAME} || die
	ln -s ${SONAME} lib/libsuperlu_dist.so || die

	use static-libs && rm -f SRC/*.o &&	emake superlulib \
		PIC="" ARCH="$(tc-getAR)" ARCHFLAGS="cr" RANLIB="$(tc-getRANLIB)"
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
