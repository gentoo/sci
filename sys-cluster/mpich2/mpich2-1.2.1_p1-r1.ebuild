# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
PYTHON_DEPEND="2"

inherit eutils fortran python mpi

MY_PV=${PV/_/}
DESCRIPTION="MPICH2 - A portable MPI implementation"
HOMEPAGE="http://www.mcs.anl.gov/research/projects/mpich2/index.php"
SRC_URI="http://www.mcs.anl.gov/research/projects/mpich2/downloads/tarballs/${MY_PV}/${PN}-${MY_PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="+cxx debug doc fortran pvfs2 threads romio mpi-threads"

MPI_UNCLASSED_BLOCKERS="media-sound/mpd"

COMMON_DEPEND="dev-libs/libaio
	romio? ( net-fs/nfs-utils )
	pvfs2? ( >=sys-cluster/pvfs2-2.7.0 )
	$(mpi_imp_deplist)"

DEPEND="${COMMON_DEPEND}
	dev-lang/perl
	sys-devel/libtool"

RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}"/${PN}-${MY_PV}

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup

	MPI_ESELECT_FILE="eselect.mpi.mpich2"

	if use fortran ; then
		FORTRAN="g77 gfortran ifort ifc"
		fortran_pkg_setup
	fi

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
	# Upstream trunk, r5843
	epatch "${FILESDIR}"/0001-MPD_CONF_FILE-should-be-readable.patch
	# Upstream trunk, r5844
	epatch "${FILESDIR}"/0002-mpd_conf_file-search-order.patch
	# Upstream trunk, r5845
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

	# 293665:  Should check in on MPICH2_MPIX_FLAGS in later releases
	# (>1.3) as this is seeing some development in trunk as of r6350.
	sed -i \
		-e 's|\(WRAPPER_[A-Z90]*FLAGS\)="@.*@"|\1=""|' \
		src/env/mpi*.in || die
}

src_configure() {
	local c="--enable-sharedlibs=gcc"
	local romio_conf

	# The configure statements can be somewhat confusing, as they
	# don't all show up in the top level configure, however, they
	# are picked up in the children directories.

	use debug && c="${c} --enable-g=all --enable-debuginfo"

	if use mpi-threads; then
		# MPI-THREAD requries threading.
		c="${c} --with-thread-package=pthreads"
		c="${c} --enable-threads=default"
	else
		if use threads ; then
			c="${c} --with-thread-package=pthreads"
		else
			c="${c} --with-thread-package=none"
		fi
		c="${c} --enable-threads=single"
	fi

	# enable f90 support for appropriate compilers
	case "${FORTRANC}" in
	    gfortran|if*)
			c="${c} --enable-f77 --enable-f90";;
	    g77)
			c="${c} --enable-f77 --disable-f90";;
	esac

	if use pvfs2; then
		# nfs and ufs are default.
	    romio_conf="--with-file-system=pvfs2+nfs+ufs --with-pvfs2=/usr"
	fi

	! mpi_classed && c="${c} --sysconfdir=/etc/${PN}"
	econf $(mpi_econf_args) ${c} ${romio_conf} \
		--docdir=$(mpi_root)/usr/share/doc/${PF} \
		--with-pm=mpd:hydra:gforker \
		--disable-mpe \
		$(use_enable romio) \
		$(use_enable cxx) \
		|| die
}

src_compile() {
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
	local d=$(echo ${D}/$(mpi_root)/ | sed 's,///*,/,g')
	local f

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
		rm -rf "${d}"usr/share/doc/www*
	else
		mpi_dodir /usr/share/doc/${PF}/www
		mv "${d}"usr/share/doc/www*/* "${d}"usr/share/doc/${PF}/www/
	fi

	mpi_imp_add_eselect

	# See #316937
	MPD_PYTHON_MODULES=""
	for f in "${d}"usr/bin/*.py; do
		MPD_PYTHON_MODULES="${MPD_PYTHON_MODULES} ${f##${d}usr/bin}"
	done
}

pkg_postinst() {
	local f
	local d=$(mpi_root)

	# Here so we can play with ebuild commands as a normal user
	chown root:root "${ROOT}"${MPD_CONF_FILE_DIR}/mpd.conf
	chmod 600 "${ROOT}"${MPD_CONF_FILE_DIR}/mpd.conf

	for f in ${MPD_PYTHON_MODULES}; do
		python_mod_optimize ${d}/usr/bin/${f}
	done

	elog ""
	elog "MPE2 has been removed from this ebuild and now stands alone"
	elog "as sys-cluster/mpe2."
	elog ""

}

pkg_postrm() {
	local f
	local d=$(mpi_root)

	for f in ${MPD_PYTHON_MODULES}; do
		python_mod_cleanup ${d}/usr/bin/${f}
	done
}
