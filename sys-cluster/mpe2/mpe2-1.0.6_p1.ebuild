# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MPI_PKG_NEED_IMPS="openmpi mpich2"

inherit eutils fortran-2 java-utils-2 mpi

MY_P=${P/_/}
DESCRIPTION="MPI development tools"
HOMEPAGE="http://www-unix.mcs.anl.gov/perfvis/download/index.htm"
SRC_URI="ftp://ftp.mcs.anl.gov/pub/mpi/${PN%2}/${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug fortran minimal threads"

COMMON_DEPEND="$(mpi_pkg_deplist)
	!minimal? ( x11-libs/libXtst
		x11-libs/libXi )"

DEPEND="!minimal? ( >=virtual/jdk-1.4 )
	${COMMON_DEPEND}"

RDEPEND="!minimal? ( >=virtual/jre-1.4 )
	${COMMON_DEPEND}"

S="${WORKDIR}"/${MY_P}
MPE_IMP=""

# README:
# This ebuild is created to handle building with both mpich2 and openmpi.
# However, without empi (in the science overlay), and some further
# conversion to use mpi.eclass, we can only handle one implementation
# at a time.  I still believe it's better to have the ebuild setup
# correctly in preperation.

pkg_setup() {
	fortran-2_pkg_setup
	local i

	MPE_IMP=$(mpi_pkg_base_imp)

	if use threads; then
		if ! built_with_use ${CATEGORY}/${MPE_IMP} threads; then
			eerror "Thread logging support in ${P} requires you build"
			eerror "${CATEGORY}/${MPE_IMP} with threading support."
			die "Fix your USE flags."
		fi
	fi

	export JFLAGS="${JFLAGS} $(java-pkg_javac-args)"

	if [[ "${MPE_IMP}" == openmpi ]] && [ -z "${MPE2_FORCE_OPENMPI_TEST}" ]; then
		elog ""
		elog "Currently src_test fails on collchk with openmpi, hence"
		elog "testing is disabled by default.  If you would like to"
		elog "force testing, please add MPE_FORCE_OPENMPI_TEST=1"
		elog "to your environment."
		elog ""
	fi

	einfo "Building with support for: ${CATEGORY}/${MPE_IMP}"
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Don't assume path contains ./
	sed -i 's,\($MPERUN\) $pgm,\1 ./$pgm,' sbin/mpetestexeclog.in

	epatch "${FILESDIR}"/slog2sdk-trace_rlog-makefile-fixes.patch
	epatch "${FILESDIR}"/slog2sdk-trace_sample-makefile-fixes.patch
}

src_compile() {
	local c="--with-mpicc=$(mpi_pkg_cc)"
	local d=$(mpi_root)

	if [ -n "$(tc-getFC)" -a -n "$(mpi_pkg_f77)" ]; then
		c="${c} --with-mpif77=$(mpi_pkg_f77)"
		export F77=$(tc-getFC)
	else
		c="${c} --disable-f77"
	fi

	if use minimal; then
		c="${c} --enable-slog2=no --disable-rlog --disable-sample"
	else
		c="${c} --with-java2=$(java-config --jdk-home) --enable-slog2=build"
	fi

	if [[ "${MPE_IMP}" == openmpi ]]; then
		c="${c} --disable-rlog --disable-sample"
	fi

	mpi_pkg_set_env
	econf $(mpi_econf_args) ${c} \
		--sysconfdir=/etc/$(mpi_class)/${PN} \
		--with-htmldir=${d}usr/share/${PN} \
		--with-docdir=${d}usr/share/${PN} \
		--enable-collchk \
		--enable-wrappers \
		$(use_enable !minimal graphics) \
		$(use_enable threads threadlogging) \
		$(use_enable debug g) \
		|| die
	emake || die
	mpi_pkg_restore_env
}

src_test() {
	local rc
	local d=$(mpi_root)

	cd "${S}"

	if [[ "${MPE_IMP}" == mpich2 ]]; then
		"${ROOT}"${d}usr/bin/mpd -d --pidfile="${T}"/mpd.pid
	elif [[ "${MPE_IMP}" == openmpi* ]] && [ -z "${MPE2_FORCE_OPENMPI_TEST}" ]; then
		elog
		elog "Skipping tests for openmpi"
		elog
		return 0
	fi

	emake \
		CC="${S}"/bin/mpecc \
		FC="${S}"/bin/mpefc \
		MPERUN="${ROOT}${d}usr/bin/mpiexec -n 4" \
		CLOG2TOSLOG2="${S}/src/slog2sdk/bin/clog2TOslog2" \
		check;
		rc=${?}
	if [[ "${MPE_IMP}" == mpich2 ]]; then
		"${ROOT}"${d}usr/bin/mpdallexit || kill $(<"${T}"/mpd.pid)
	fi

	return ${rc}
}

src_install() {
	local d=$(mpi_root)
	cd "${S}"
	emake DESTDIR="${D}" install || die
	rm -f "${D}"/${d}usr/sbin/mpeuninstall
}
