# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
inherit eutils fortran mpi

MY_PV=${PV/_/}
DESCRIPTION="MPICH2 - A portable MPI implementation"
HOMEPAGE="http://www.mcs.anl.gov/research/projects/mpich2/index.php"
SRC_URI="http://www.mcs.anl.gov/research/projects/mpich2/downloads/tarballs/${MY_PV}/${PN}-${MY_PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="+cxx debug doc fortran pvfs2 threads romio mpi-threads"

MPI_UNCLASSED_BLOCKERS="media-sound/mpd"

COMMON_DEPEND="dev-lang/perl
	>=dev-lang/python-2.3
	romio? ( net-fs/nfs-utils )
	pvfs2? ( >=sys-cluster/pvfs2-2.7.0 )
	dev-libs/libaio
	$(mpi_imp_deplist)"

DEPEND="${COMMON_DEPEND}
	sys-devel/libtool"

RDEPEND="${COMMON_DEPEND}
	net-misc/openssh"

S="${WORKDIR}"/${PN}-${MY_PV}

pkg_setup() {
	MPI_ESELECT_FILE="eselect.mpi.mpich2"

	if [ -n "${MPICH_CONFIGURE_OPTS}" ]; then
	    elog "User-specified configure options are ${MPICH_CONFIGURE_OPTS}."
	else
	    elog "User-specified configure options are not set."
	    elog "If needed, see the docs and set MPICH_CONFIGURE_OPTS."
	fi

	if use fortran ; then
		FORTRAN="g77 gfortran ifort ifc"
		fortran_pkg_setup
	fi

	if use mpi-threads && ! use threads; then
		die "USE=mpi-threads requires USE=threads"
	fi

	if mpi_classed; then
		MPD_CONF_FILE_DIR=/etc/$(mpi_class)
	else
		MPD_CONF_FILE_DIR=/etc/${PN}
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# A lot of these patches touch Makefile.in and configure files.
	# While it would be nice to regenerate everything, mpich2 uses
	# simplemake instead of automake, so we're doing this for now
	# and hoping for a receptive upstream.

	# 0001 and 0003 are in upstream repos.  0003 has been submitted.
	epatch "${FILESDIR}"/0001-MPD_CONF_FILE-should-be-readable.patch
	epatch "${FILESDIR}"/0002-mpd_conf_file-search-order.patch
	epatch "${FILESDIR}"/0003-Fix-pkgconfig-for-mpich2-ch3-v1.2.1.patch

	# We need f90 to include the directory with mods, and to
	# fix hardcoded paths for src_test()
	# Submitted upstream.
	sed -i \
		-e "s,F90FLAGS\( *\)=,F90FLAGS\1?=," \
		-e "s,\$(bindir)/,${S}/bin/,g" \
		-e "s,@MPIEXEC@,${S}/bin/mpiexec,g" \
		$(find ./test/ -name 'Makefile.in') || die

	if ! use romio; then
		# These tests in errhan/ rely on MPI::File ...which is in romio
		echo "" > test/mpi/errors/cxx/errhan/testlist
	fi
}

src_compile() {
	local c="${MPICH_CONFIGURE_OPTS} --enable-sharedlibs=gcc"
	local romio_conf

	# The configure statements can be somewhat confusing, as they
	# don't all show up in the top level configure, however, they
	# are picked up in the children directories.

	use debug && c="${c} --enable-g=all --enable-debuginfo"

	if use threads ; then
	    c="${c} --with-thread-package=pthreads"
	else
	    c="${c} --with-thread-package=none"
	fi

	# enable f90 support for appropriate compilers
	case "${FORTRANC}" in
	    gfortran|if*)
			c="${c} --enable-f77 --enable-f90";;
	    g77)
			c="${c} --enable-f77 --disable-f90";;
	esac

	if use mpi-threads; then
		c="${c} --enable-threads=default"
	else
		c="${c} --enable-threads=single"
	fi

	if use pvfs2; then
		# nfs and ufs are defaults in 1.0.8 at least.
	    romio_conf="--with-file-system=pvfs2+nfs+ufs --with-pvfs2=/usr"
	fi

	! mpi_classed && c="${c} --sysconfdir=/etc/${PN}"
	econf $(mpi_econf_args) ${c} ${romio_conf} \
		--docdir=$(mpi_root)/usr/share/doc/${PF} \
		--with-pm=mpd:gforker \
		--disable-mpe \
		$(use_enable romio) \
		$(use_enable cxx) \
		|| die
	# Oh, the irony.
	# http://wiki.mcs.anl.gov/mpich2/index.php/Frequently_Asked_Questions#Q:_The_build_fails_when_I_use_parallel_make.
	# https://trac.mcs.anl.gov/projects/mpich2/ticket/297
	emake -j1 || die
}

src_test() {
	local rc

	cp "${FILESDIR}"/mpd.conf "${T}"/mpd.conf || die
	chmod 600 "${T}"/mpd.conf
	export MPD_CONF_FILE="${T}/mpd.conf"
	"${S}"/bin/mpd --daemon --pid="${T}"/mpd.pid

	make \
		CC="${S}"/bin/mpicc \
		CXX="${S}"/bin/mpicxx \
		FC="${S}"/bin/mpif77 \
		F90="${S}"/bin/mpif90 \
		F90FLAGS="${F90FLAGS} -I${S}/src/binding/f90/" \
		testing
	rc=$?

	"${S}"/bin/mpdallexit || kill $(<"${T}"/mpd.pid)
	return ${rc}
}

src_install() {
	local d=$(mpi_root)

	emake DESTDIR="${D}" install || die

	dodir ${MPD_CONF_FILE_DIR}
	insinto ${MPD_CONF_FILE_DIR}
	doins "${FILESDIR}"/mpd.conf || die

	mpi_dodir /usr/share/doc/${PF}
	mpi_dodoc COPYRIGHT README CHANGES RELEASE_NOTES || die
	mpi_newdoc src/pm/mpd/README README.mpd || die
	if use romio; then
		mpi_newdoc src/mpi/romio/README README.romio || die
	fi

	if ! use doc; then
		rm -rf "${D}"/${d}/usr/share/doc/www*
	else
		mpi_dodir /usr/share/doc/${PF}/www
		mv "${D}"/${d}/usr/share/doc/www*/* "${D}"/${d}/usr/share/doc/${PF}/www/
	fi

	mpi_imp_add_eselect
}

pkg_postinst() {
	# Here so we can play with ebuild commands as a normal user
	chown root:root "${ROOT}"${MPD_CONF_FILE_DIR}/mpd.conf
	chmod 600 "${ROOT}"${MPD_CONF_FILE_DIR}/mpd.conf

	elog ""
	elog "MPE2 has been removed from this ebuild and now stands alone"
	elog "as sys-cluster/mpe2."
	elog ""
}
