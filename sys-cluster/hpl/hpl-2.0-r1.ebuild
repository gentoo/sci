# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils mpi toolchain-funcs

DESCRIPTION="High-Performance Linpack Benchmark for Distributed-Memory Computers"
HOMEPAGE="http://www.netlib.org/benchmark/hpl/"
SRC_URI="http://www.netlib.org/benchmark/hpl/hpl-${PV}.tar.gz"

SLOT="0"
LICENSE="HPL"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	$(mpi_pkg_deplist)
	virtual/blas
	virtual/lapack"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	local mpicc_path="$(mpi_pkg_cc)"

	cp setup/Make.Linux_PII_FBLAS Make.gentoo_hpl_fblas_x86 || die
	sed -i \
		-e "/^TOPdir/s,= .*,= ${S}," \
		-e '/^HPL_OPTS\>/s,=,= -DHPL_DETAILED_TIMING -DHPL_COPY_L,' \
		-e '/^ARCH\>/s,= .*,= gentoo_hpl_fblas_x86,' \
		-e '/^MPdir\>/s,= .*,=,' \
		-e '/^MPlib\>/s,= .*,=,' \
		-e "/^LAlib\>/s,= .*,= $($(tc-getPKG_CONFIG) --libs-only-l blas lapack)," \
		-e "/^LINKER\>/s,= .*,= ${mpicc_path}," \
		-e "/^CC\>/s,= .*,= ${mpicc_path}," \
		-e "/^LINKFLAGS\>/s|= .*|= ${LDFLAGS} $($(tc-getPKG_CONFIG) --libs-only-L blas lapack)|" \
		Make.gentoo_hpl_fblas_x86 || die
	default
}

src_compile() {
	# do NOT use emake here
	mpi_pkg_set_env
	# parallel make failure bug #321539
	HOME=${WORKDIR} emake -j1 arch=gentoo_hpl_fblas_x86
	mpi_pkg_restore_env
}

src_install() {
	mpi_dobin bin/gentoo_hpl_fblas_x86/xhpl
	mpi_dolib.a lib/gentoo_hpl_fblas_x86/libhpl.a
	mpi_dodoc INSTALL BUGS COPYRIGHT HISTORY README TUNING \
		bin/gentoo_hpl_fblas_x86/HPL.dat
	mpi_doman man/man3/*.3
	if use doc; then
		mpi_dohtml -r www/*
	fi
}

pkg_postinst() {
	local d=$(mpi_root)
	einfo "Remember to copy $(mpi_root)usr/share/doc/${PF}/HPL.dat to your working directory first!"
	einfo "Typically one may run hpl by executing the following:"
	einfo "\"mpiexec -np 4 /usr/bin/xhpl\""
	einfo "where -np specifies the number of processes."
}
