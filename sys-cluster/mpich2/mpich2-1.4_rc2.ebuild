# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils mpi toolchain-funcs

MY_PV=${PV/_/}
DESCRIPTION="MPICH2 - A portable MPI implementation"
HOMEPAGE="http://www.mcs.anl.gov/research/projects/mpich2/index.php"
SRC_URI="http://www.mcs.anl.gov/research/projects/mpich2/downloads/tarballs/${MY_PV}/${PN}-${MY_PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="+cxx debug doc fortran threads romio mpi-threads"

COMMON_DEPEND="dev-libs/libaio
	>=sys-apps/hwloc-1.1.1
	romio? ( net-fs/nfs-utils )
	$(mpi_imp_deplist)"

DEPEND="${COMMON_DEPEND}
	dev-lang/perl
	sys-devel/libtool"

RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}"/${PN}-${MY_PV}

pkg_setup() {
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
		src/env/*.conf.in || die
}

src_configure() {
	local c="--enable-shared"
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

	# enable f90 support for appropriate compilers
	case "$(tc-getFC)" in
	    gfortran|if*)
			c="${c} --enable-f77 --enable-fc";;
	    g77)
			c="${c} --enable-f77 --disable-fc";;
	esac

	! mpi_classed && c="${c} --sysconfdir=/etc/${PN}"
	econf $(mpi_econf_args) ${c} ${romio_conf} \
		--docdir=$(mpi_root)/usr/share/doc/${PF} \
		--with-pm=hydra \
		--disable-mpe \
		--with-hwloc-prefix=/usr \
		--disable-fast \
		--enable-smpcoll \
		$(use_enable romio) \
		$(use_enable cxx) \
		|| die
}

src_compile() {
	# Oh, the irony.
	# http://wiki.mcs.anl.gov/mpich2/index.php/Frequently_Asked_Questions#Q:_The_build_fails_when_I_use_parallel_make.
	# https://trac.mcs.anl.gov/projects/mpich2/ticket/711
	emake -j1 || die
}

src_test() {
	# See #362655 and comments in the testlist files.
	# large_message:  only on machines with > 8gb of ram
	# bcastlength:  This is an extension to MPI that's not necessary
	# non_zero_root: performance test
	# Also note that I/O tests may fail on non-local filesystems.
	sed -i '/^[# ]*large_message/d' test/mpi/pt2pt/testlist || die
	sed -i '/^[# ]*bcastlength/d' test/mpi/errors/coll/testlist || die
	sed -i '/^[# ]*non_zero_root/d' test/mpi/perf/testlist || die

	emake -j1 \
		CC="${S}"/bin/mpicc \
		CXX="${S}"/bin/mpicxx \
		F77="${S}"/bin/mpif77 \
		FC="${S}"/bin/mpif90 \
		testing
}

src_install() {
	local d=$(echo ${D}/$(mpi_root)/ | sed 's,///*,/,g')

	emake -j1 DESTDIR="${D}" install || die

	mpi_dodir /usr/share/doc/${PF}
	mpi_dodoc COPYRIGHT README CHANGES RELEASE_NOTES || die
	mpi_newdoc src/pm/hydra/README README.hydra || die
	if use romio; then
		mpi_newdoc src/mpi/romio/README README.romio || die
	fi

	if ! use doc; then
		rm -rf "${d}"usr/share/doc/${PF}/www*
	fi

	mpi_imp_add_eselect
}
