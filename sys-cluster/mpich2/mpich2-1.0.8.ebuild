# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python eutils fortran mpi

DESCRIPTION="MPICH2 - A portable MPI implementation"
HOMEPAGE="http://www-unix.mcs.anl.gov/mpi/mpich2"
SRC_URI="http://www.mcs.anl.gov/research/projects/mpich2/downloads/tarballs/${PV}/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="nocxx debug doc fortran pvfs2 threads romio mpi-threads"

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

	python_version
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# A lot of these patches touch Makefile.in and configure files.
	# While it would be nice to regenerate everything, mpich2 uses
	# simplemake instead of automake, so we're doing this for now
	# and hoping for a receptive upstream.

	# #220877
	sed -i 's/-fpic/-fPIC/g' \
		$(grep -lr -e '-fpic' "${S}"/) || die "failed to change -fpic to -fPIC"

	# Put python files in site-packages where they belong.
	# This isn't the prettiest little patch, but it does
	# move python files out of /usr/bin/
	epatch "${FILESDIR}"/${P}-site-packages-py.patch

	# Respect the env var MPD_CONF_FILE
	# TODO:  Send upstream
	epatch "${FILESDIR}"/${P}-mpdconf-env.patch

	# Fix gforker instal-alt
	# TODO:  Send upstream
	epatch "${FILESDIR}"/${P}-gforker-install-alt-fix.patch

	# We need f90 to include the directory with mods, and to
	# fix hardcoded paths for src_test()
	sed -i \
		-e "s,F90FLAGS\( *\)=,F90FLAGS\1?=," \
		-e "s,\$(bindir)/,${S}/bin/,g" \
		-e "s,@MPIEXEC@,${S}/bin/mpiexec,g" \
		$(find ./test/ -name 'Makefile.in') || die

	# 254167, I'm pretty sure they meant srcdir in the path to remove files.
	# TODO:  Send upstream
	sed -i 's:scrdir:srcdir:g' "${S}"/src/pm/mpd/Makefile.in || die

	# #257821, fix the pkgconfig file.
	# TODO:  Send upstream
	epatch "${FILESDIR}"/${P}-pkgconfig.patch

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
		c="${c} --enable-threads=multiple"
	else
		c="${c} --enable-threads=single"
	fi

	if use pvfs2; then
		# nfs and ufs are defaults in 1.0.8 at least.
	    romio_conf="--with-file-system=pvfs2+nfs+ufs --with-pvfs2=/usr"
	fi

	! mpi_classed && c="${c} --sysconfdir=/etc/${PN}"
	econf $(mpi_econf_args) ${c} ${romio_conf} \
		--docdir=$(mpi_root)/usr/share/doc/${PF}
		--with-pm=mpd:gforker \
		--disable-mpe \
		$(use_enable romio) \
		$(use_enable !nocxx cxx) \
		|| die
	# Oh, the irony.
	# http://www.mcs.anl.gov/research/projects/mpich2/support/index.php?s=faqs#parmake
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
	mpi_dodoc COPYRIGHT README README.romio README.testing \
		CHANGES README.developer RELEASE_NOTES || die
	mpi_newdoc src/pm/mpd/README README.mpd || die

	if ! use doc; then
		rm -rf "${D}"/${d}/usr/share/doc/www*
	else
		mpi_dodir /usr/share/doc/${PF}/www
		mv "${D}"/${d}/usr/share/doc/www*/* "${D}"/${d}/usr/share/doc/${PF}/www/
	fi

	#TODO: Need to handle python path here if mpi_classed?
	cp "${FILESDIR}"/${PN}.envd "${T}"/
	sed -i "s,@MPD_CONF_FILE_DIR@,${MPD_CONF_FILE_DIR}," \
		"${T}"/${PN}.envd

	if mpi_classed; then
		newenvd "${T}"/${PN}.envd 25mpich2-$(mpi_class)
	else
		newenvd "${FILESDIR}"/${PN}.envd 25mpich2
	fi

	mpi_imp_add_eselect
}

pkg_postinst() {
	# Here so we can play with ebuild commands as a normal user
	chown root:root "${ROOT}"${MPD_CONF_FILE_DIR}/mpd.conf
	chmod 600 "${ROOT}"${MPD_CONF_FILE_DIR}/mpd.conf

	python_mod_optimize $(mpi_root)/usr/$(get_libdir)/python${PYVER}/site-packages/${PN}
	elog ""
	elog "MPE2 has been removed from this ebuild and now stands alone"
	elog "as sys-cluster/mpe2."
	elog ""
}

pkg_postrm() {
	python_mod_cleanup $(mpi_root)/usr/$(get_libdir)/python${PYVER}/site-packages/${PN}
}

