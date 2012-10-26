# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

FORTRAN_NEEDED=fortran

inherit autotools eutils fortran-2 mpi toolchain-funcs versionator

MY_PV=${PV/_/}
DESCRIPTION="A high performance and portable MPI implementation"
HOMEPAGE="http://www.mcs.anl.gov/research/projects/mpich2/index.php"
SRC_URI="http://www.mcs.anl.gov/research/projects/mpich2/downloads/tarballs/${MY_PV}/${PN}-${MY_PV}.tar.gz"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="+cxx debug doc fortran mpi-threads romio threads"

COMMON_DEPEND="
	dev-libs/libaio
	sys-apps/hwloc
	romio? ( net-fs/nfs-utils )
	$(mpi_imp_deplist)"

DEPEND="${COMMON_DEPEND}
	dev-lang/perl
	sys-devel/libtool"

RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}"/${PN}-${MY_PV}

pkg_setup() {
	FORTRAN_STANDARD="77 90"
	fortran-2_pkg_setup
	MPI_ESELECT_FILE="eselect.mpi.mpich2"

	if use mpi-threads && ! use threads; then
		ewarn "mpi-threads requires threads, assuming that's what you want"
	fi

	if mpi_classed; then
		MPD_CONF_FILE_DIR=/etc/$(mpi_class)
	else
		MPD_CONF_FILE_DIR=/etc/${PN}
	fi

}

src_prepare() {
	# Cannot use bin/mpiexec as hydra is built by autotools and is
	# a shell wrapped executable.
	sed -i \
		-e "s,@MPIEXEC@,${S}/src/pm/hydra/mpiexec.hydra,g" \
		$(find ./test/ -name 'Makefile.in') || die

	# #293665
	# We could use MPICH2LIB_XFLAGS here and unset the cooresponding ones
	# in the environment, however that's messy and doesn't for for LDFLAGS.
	sed -i \
		-e 's,\(.*=\ *\)"@WRAPPER_[A-Z]*FLAGS@",\1"",' \
		src/env/*.in || die

	# See
	# http://lists.mcs.anl.gov/pipermail/mpich-discuss/2011-August/010680.html
	# http://lists.mcs.anl.gov/pipermail/mpich-discuss/2011-August/010678.html
	# and countless other sources pointing out the insanity.
	sed -i \
		-e 's|prefix=${DESTDIR}|prefix=|g' \
		-e 's|dir=${DESTDIR}|dir=|g' \
		Makefile.in || die

	sed -i \
		-e "s|prefix='\${DESTDIR}|prefix='|" \
		-e "s|dir='\${DESTDIR}|dir='|" \
		src/env/Makefile.in || die

	# 369263 and 1500 upstream.
	epatch "${FILESDIR}"/fix-pkg-config-files.patch

	# 393361, backport of r8809 upstream.
	epatch "${FILESDIR}"/mpich2-hvector.patch

	AT_M4DIR="${S}"/confdb eautoreconf
}

src_configure() {
	local c="--enable-shared --disable-rpath"
	local romio_conf

	# The configure statements can be somewhat confusing, as they
	# don't all show up in the top level configure, however, they
	# are picked up in the children directories.

	use debug && c="${c} --enable-g=dbg --enable-debuginfo"

	if use mpi-threads; then
		# MPI-THREAD requries threading.
		c="${c} --with-thread-package=pthreads"
		c="${c} --enable-threads=runtime"
	else
		if use threads ; then
			c="${c} --with-thread-package=pthreads"
		else
			c="${c} --with-thread-package=none"
		fi
		c="${c} --enable-threads=single"
	fi

	if ! mpi_classed; then
		c="${c} --sysconfdir=${EPREFIX}/etc/${PN}"
		c="${c} --docdir=${EPREFIX}/usr/share/doc/${PF}"
	else
		c="${c} --docdir=$(mpi_root)/usr/share/doc/${PF}"
	fi

	econf $(mpi_econf_args) ${c} ${romio_conf} \
		--with-pm=hydra \
		--disable-mpe \
		--with-hwloc-prefix="${EPREFIX}/usr" \
		--disable-fast \
		--enable-smpcoll \
		$(use_enable romio) \
		$(use_enable cxx) \
		$(use_enable fortran f77) \
		$(use_enable fortran fc)
}

# Oh, the irony.
# http://wiki.mcs.anl.gov/mpich2/index.php/Frequently_Asked_Questions#Q:_The_build_fails_when_I_use_parallel_make.
# https://trac.mcs.anl.gov/projects/mpich2/ticket/711
MAKEOPTS+=" -j1"

src_test() {
	# See #362655 and comments in the testlist files.
	# large_message:  only on machines with > 8gb of ram
	# bcastlength:  This is an extension to MPI that's not necessary
	# non_zero_root: performance test
	# Also note that I/O tests may fail on non-local filesystems.
	sed -i '/^[# ]*large_message/d' test/mpi/pt2pt/testlist || die
	sed -i '/^[# ]*bcastlength/d' test/mpi/errors/coll/testlist || die
	sed -i '/^[# ]*non_zero_root/d' test/mpi/perf/testlist || die

	# Failing tests based on requiring MPI_THREAD_MULTIPLE.
	# http://lists.mcs.anl.gov/pipermail/mpich-discuss/2012-January/011618.html
	sed -i \
		-e '/^[# ]*pt2pt/d' \
		-e '/^[# ]*comm/d' \
		-e '/^[# ]*spawn/d' \
		test/mpi/threads/testlist || die

	emake \
		CC="${S}"/bin/mpicc \
		CXX="${S}"/bin/mpicxx \
		F77="${S}"/bin/mpif77 \
		FC="${S}"/bin/mpif90 \
		testing
}

src_install() {
	local d=$(echo ${ED}/$(mpi_root)/ | sed 's,///*,/,g')

	default

	mpi_dodir /usr/share/doc/${PF}
	mpi_dodoc COPYRIGHT README CHANGES RELEASE_NOTES
	mpi_newdoc src/pm/hydra/README README.hydra
	if use romio; then
		mpi_newdoc src/mpi/romio/README README.romio
	fi

	if ! use doc; then
		rm -rf "${d}"usr/share/doc/${PF}/www*
	fi

	mpi_imp_add_eselect
}
