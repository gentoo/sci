# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Description: This eclass is used to allow for the separation of mpi
#              implementations and dependant programs/libraries in
#              /usr/lib/mpi/<implementation>.
#
# Author(s): Justin Bronder <jsbronder@gentoo.org>
#
# Basic idea is directly stolen from crossdev and hence really relies on using
# sys-cluster/empi.  EmergeMPI basically creates new categories, pulls in a
# single MPI providing ebuild that uses this eclass and builds.  This eclass
# handles pushing the entire install to a save place, /usr/lib/mpi/<name>.
# Packages that depend on MPI can also use this eclass to get installed to
# the same place using the correct MPI implementation.

# Currently only autotools-enabled packages are handled with any sort of
# elegance, and dealing with the standard Makefile-style builds that
# are typical in hpc probably can't be made much easier.

# NOTE:  If using this eclass to build an implementation, you need to define
# MPI_ESELECT_FILE which is the path relative to FILESDIR where the eselect
# definition file can be found.


# FUNCTIONS, at least those that are worth caring about!

# mpi_src_compile:   For each implementation, set $S correctly and then run
#                    through do_config and do_make.  Finally restore $S

# mpi_src_install:   For each implementation, set $S correctly, run
#                    do_make_install and restore $S.

# mpi_pkg_deplist:	 Prints deps for mpi enabled packages.  Basically if using
#					 empi, then we dep on empi-enabled implementations,
#                    otherwise, the dep is just on virtual/mpi

# mpi_imp_deplist:   Prints deps for mpi implementations.  As empi guarantees
#                    blockers cannot be installed at the same root, this deps
#                    on eselect-mpi for empi builds.  Otherwise, prints a list
#                    of blockers (all other mpi implementations).

# mpi_built_with:    Get the ${PN} of the implementation that was used to get
#                    mpicc etc.  

# get_mpi_dir:       Given an implementation, returns the base directory to
#                    that programs should install to.  I.E. --prefix for
#                    autoconf.

# is_empi_build:	 Are we building with empi?  [[ ${CATEGORY} == mpi-* ]] as
# 					 empi forces this just so we can do that.

# FUNCTIONS, directly used by the above interesting ones.

# mpi_set_env <imp>:  For lack of a better name, just exports the following based
#                     on the desired implementation:  CC, CXX, F77, FC, PATH
#                     Set $mpi_env to "mpi_none" to ensure that this function
#					  is not called.

# mpi_restore_env:    Undo the above.

# For the following functions and those that call them, I've used indirect
# referencing to allow for a clean way to have both defaults and to allow
# different actions to be taken per implementation.  Preference is given first
# to ${implementation}_${var}, then mpi_${var} and finally defaults will be
# used.  All variables also allow "mpi_none", which disables that action.
#
# *_conf_cmd:  configure command, default: econf
# *_conf_args: configure arguments, no default
#                HOWEVER, note that prefix, mandir, infodir and datadir are
#                set if ${S}/configure is executable.  Pass "mpi_none" to
#                disable this.
# *_make_cmd:    make command, default emake
# *_make_args:   make arguments, no default
# *_make_install_cmd:  make install command, default emake
# *_make_install_args: make install arguments, default 'DESTDIR=${D} install'



# mpi_do_config:  $S should be set correctly to some ${P}-${imp}.  Changes to
#                 that dir, calls mpi_set_env, $conf_cmd $conf_args, and
#                 rcalls mpi_restore_env.

# mpi_do_make:           Same as above but for building.
# mpi_do_make_install:   Same as above but for installing.


# Variables:
# MPI_ESELECT_FILE:  	Name of the eselect file in ${FILESDIR}
# MPI_NOEMPI_BLOCKERS: 	String of packages we should block against if not using
# 						empi.  See mpich2 and mpd.
# MPI_EMPI_COMPAT:		String of all base implementations that this package
# 						works with.  See __MPI_EMPI_COMPAT, this is a list of
# 						[><=]${PN}-${PVR} put into DEPEND with ||.

inherit multilib flag-o-matic

__MPI_EMPI_COMPAT="
	>=openmpi-1.2.5-r1
	>=lam-mpi-7.1.4-r1
	>=openib-mvapich2-1.0.1-r1
	>=mpich2-1.0.8"
MPI_ALL_IMPS="mpich mpich2 openmpi lam-mpi openib-mvapich2"

MPI_EMPI_COMPAT="${MPI_EMPI_COMPAT:-${__MPI_EMPI_COMPAT}}"
#TODO: doc
mpi_pkg_deplist() {
	local i ver
	if [ -z "$(get_imp)" ]; then
		ver="virtual/mpi"
		for i in ${MPI_NOEMPI_BLOCKERS}; do
			ver="${ver} !${i}"
		done
	else
		for i in ${MPI_EMPI_COMPAT}; do
			ver="${ver} ${CATEGORY}/${i}"
		done
		ver="|| (${ver} ) app-admin/eselect-mpi"
	fi
	echo "${ver}"
}

mpi_imp_deplist() {
	local i ver
	if ! is_empi_imp_build; then
		for i in ${MPI_ALL_IMPS}; do
			[ "${i}" != "${PN}" ] && ver="${ver} !sys-cluster/${i}"
		done
		for i in ${MPI_NOEMPI_BLOCKERS}; do
			ver="${ver} !${i}"
		done
	else
		ver="app-admin/eselect-mpi"
	fi
	echo "${ver}"
}

is_imp_build() { [[ ${MPI_ALL_IMPS} == *${PN}* ]]; }
is_empi_build() { [[ ${CATEGORY} == mpi-* ]]; }
is_empi_imp_build() { is_imp_build && is_empi_build; }


get_imp() {
	[[ ${CATEGORY} == mpi-* ]] && echo "${CATEGORY}"
}

get_mpi_dir() {
	if is_empi_build; then
		echo "/usr/$(get_libdir)/mpi/${MPI_IMP}"
	fi
}

get_eselect_var() { echo "$(eselect mpi printvar ${MPI_IMP} ${1})"; }
mpi_built_with() { echo "$(get_eselect_var MPI_BUILT_WITH)"; }

# Internal use:  Get out of messy functions if we're not using empi to build and
# therefore avoid tons of file collisions.
bail_if_not_empi() { [ -z "${MPI_IMP}" ] && return 0; }

#TODO: There must be a better way?
# Currently can be turned off with mpi_env="mpi_none"
mpi_set_env() {
	local p
	[ -z "${MPI_IMP}" ] && return 0
	is_empi_imp_build && return 0
	[[ ${mpi_env} == mpi_none ]] && return 0

	p="$(get_mpi_dir)"
	
	oCC=$CC
	oCXX=$CXX
	oF77=$F77
	oFC=$FC
	oPATH=$PATH
	oLLP=${LD_LIBRARY_PATH}
	export CC=$(get_eselect_var MPI_CC)
	export CXX=$(get_eselect_var MPI_CXX)
	export F77=$(get_eselect_var MPI_F77)
	export FC=$(get_eselect_var MPI_F90)
	export PATH="$(get_eselect_var PATH):${PATH}"
	export LD_LIBRARY_PATH="$(get_eselect_var LD_LIBRARY_PATH):${LD_LIBRARY_PATH}"
# Handled by the wrappers, at least it better be.
#	append-ldflags $(eselect mpi ldflags ${MPI_IMP})
#	append-flags $(eselect mpi cflags ${MPI_IMP})
}

mpi_restore_env() {
	[ -z "${MPI_IMP}" ] && return 0
	is_empi_imp_build && return 0
	[[ ${mpi_env} == mpi_none ]] && return 0

	export CC=$oCC
	export CXX=$oCXX
	export F77=$oF77
	export FC=$oFC
	export PATH=$oPATH
	export LD_LIBRARY_PATH=$oLLP
}


# Here's what we try to get, in order.
# ${IMP_BUILT_WITH}_${var}
# mpi_${var}
get_mpi_var() {
	local varname=${1}
	local t ret

	if is_imp_build; then
		t="${PN}_${varname}"
	elif is_empi_build; then
		t=$(mpi_built_with)
		t=${t%%-[0-9]*}
		t="${t}_${varname}"
	fi
	[ -n "${t}" ] && ret="${!t}"

	if [ -z "${ret}" ]; then
		t="mpi_${varname}"
		ret=${!t}
	fi

	if [ -z "${ret}" ]; then
		case ${varname} in
			conf_cmd)
				ret="econf"
				;;
			make_cmd|make_install_cmd)
				ret="emake"
				;;
		esac
	fi
	echo "${ret}"
}

mpi_do_config() {
	local conf_cmd=$(get_mpi_var "conf_cmd")
	local conf_args=$(get_mpi_var "conf_args")
	local default_args rc d
	
	d="$(get_mpi_dir)"
	[[ "${conf_cmd}" == "mpi_none" ]] && return 0
	[[ -x ${S}/configure && -n "${MPI_IMP}" ]] \
		&& default_args="--prefix=${d}/usr/
				--mandir=${d}/usr/share/man
				--infodir=${d}/usr/share/info
				--datadir=${d}/usr/share/
				--sysconfdir=/etc/${MPI_IMP}/
				--localstatedir=/var/lib/${MPI_IMP}"
	[[ "${conf_args}" == *mpi_none* ]] && default_args=""

	mpi_set_env
	${conf_cmd} ${default_args} ${conf_args}; rc=$?
	mpi_restore_env
	return ${rc}
}

mpi_do_make() {
	local make_cmd=$(get_mpi_var "make_cmd")
	local make_args=$(get_mpi_var "make_args")
	local rc

	[[ "${make_cmd}" == "mpi_none" ]] && return 0

	mpi_set_env
	${make_cmd} ${make_args}; rc=$?
	mpi_restore_env
	return ${rc}
}


mpi_do_make_install() {
	local make_cmd=$(get_mpi_var "make_install_cmd")
	local make_args=$(get_mpi_var "make_install_args")
	local default_args="DESTDIR=\"${D}\" install"
	local rc

	[[ "${make_cmd}" == "mpi_none" ]] && return 0
	[[ "${make_args}" == "mpi_none" ]] && default_args=""

	mpi_set_env
	${make_cmd} ${default_args} ${make_args}; rc=$?
	mpi_restore_env
	return ${rc}
}

mpi_src_compile() {
	# Be nice and check at the earliest moment so the user doesn't watch
	# everything compile only to have the emerge blow up.
	if is_empi_imp_build && [ ! -f "${FILESDIR}"/${MPI_ESELECT_FILE} ]; then
		die "MPI_ESELECT_FILE is not defined/found. ${MPI_ESELECT_FILE}"
	fi

	pushd "${S}" &>/dev/null
	mpi_do_config || die "mpi_src_compile: mpi_do_config failed."
	mpi_do_make || die "mpi_src_compile: mpi_do_make failed."
	popd &>/dev/null
}

mpi_src_install() {
	pushd "${S}" &>/dev/null
	mpi_do_make_install \
		|| die "mpi_src_install(${MPI_IMP}) mpi_do_make_install failed."
	popd &>/dev/null

	[ -z "${MPI_IMP}" ] && return 0
	if is_empi_imp_build; then
		mpi_add_eselect
	fi
}

mpi_pkg_setup() {
	# Make sure this eclass should be used.
	MPI_IMP=$(get_imp)
	[ -z "${MPI_IMP}" ] && return 0
	
	if [[ -z ${MPI_IMP} ]]; then
		die "Building without empi and bail_if_not_empi failed."
	fi

	if ! is_empi_imp_build; then
		einfo "mpi: Building against implementation ${MPI_IMP}."
	fi
}

mpi_add_eselect() {
	cp "${FILESDIR}"/${MPI_ESELECT_FILE} ${T}/${MPI_IMP}.eselect || die
	sed -i \
		-e "s|@ROOT@|$(get_mpi_dir)|g" \
		-e "s|@LIBDIR@|$(get_libdir)|g" \
		-e "s|@BUILT_WITH@|${PF}|g" \
		${T}/${MPI_IMP}.eselect

	eselect mpi add "${T}"/${MPI_IMP}.eselect
}



# Handles all the mpi_{do,new} functions below.
# Not handled because there is no good way:
#	doconfd doenvd domo doinitd
mpi_do() {
	local rc prefix
	local cmd=${1}
	local ran=1
	local slash=/
	local mdir="$(get_mpi_dir)/"

	if ! is_empi_build; then
		$*
		return ${?}
	fi

	shift
	if [ "${cmd#do}" != "${cmd}" ]; then
		prefix="do"; cmd=${cmd#do}
	elif [ "${cmd#new}" != "${cmd}" ]; then
		prefix="new"; cmd=${cmd#new}
	else
		die "Unknown command passed to mpi_do: ${cmd}"
	fi
	case ${cmd} in
		bin|lib|lib.a|lib.so|sbin)
			DESTTREE="${mdir}usr" ${prefix}${cmd} $*
			rc=$?;;
		doc)
			_E_DOCDESTTREE_="../../../../${mdir}usr/share/doc/${PF}/${_E_DOCDESTTREE_}" \
				${prefix}${cmd} $*
			rc=$?;;
		html)
			_E_DOCDESTTREE_="../../../../${mdir}usr/share/doc/${PF}/www/${_E_DOCDESTTREE_}" \
				${prefix}${cmd} $*
			rc=$?;;
		exe)
			_E_EXEDESTTREE_="${mdir}${_E_EXEDESTTREE_}" ${prefix}${cmd} $*
			rc=$?;;
		man|info)
			[ -d "${D}"usr/share/${cmd} ] && mv "${D}"usr/share/${cmd}{,-orig}
			[ ! -d "${D}"${mdir}usr/share/${cmd} ] \
				&& install -d "${D}"${mdir}usr/share/${cmd} 

			ln -snf ../../${mdir}usr/share/${cmd} ${D}usr/share/${cmd}
			${prefix}${cmd} $*
			rc=$?
			rm "${D}"usr/share/${cmd}
			[ -d "${D}"usr/share/${cmd}-orig ] && mv "${D}"usr/share/${cmd}{-orig,}
			;;
		dir)
			dodir "${@/#${slash}/${mdir}${slash}}"; rc=$?;;
		hard|sym)
			${prefix}${cmd} "${mdir}$1" "${mdir}/$2"; rc=$?;;
		ins)
			INSDESTTREE="${mdir}${INSTREE}" ${cmd}${prefix} $*; rc=$?;;
		*)
			rc=0;;
	esac

	[[ ${ran} -eq 0 ]] && die "mpi_do passed unknown command: ${cmd}"
	return ${rc}
}

mpi_dobin()		{ mpi_do "dobin" 		$*; }
mpi_newbin()	{ mpi_do "newbin" 		$*; }
mpi_dodoc()		{ mpi_do "dodoc"		$*; }
mpi_newdoc()	{ mpi_do "newdoc"		$*; }
mpi_doexe()		{ mpi_do "doexe"		$*; }
mpi_newexe()	{ mpi_do "newexe"		$*; }
mpi_dohtml()	{ mpi_do "dohtml" 		$*; }
mpi_dolib() 	{ mpi_do "dolib" 		$*; }
mpi_dolib.a()	{ mpi_do "dolib.a" 		$*; }
mpi_newlib.a()	{ mpi_do "newlib.a"		$*; }
mpi_dolib.so()	{ mpi_do "dolib.so"		$*; }
mpi_newlib.so()	{ mpi_do "newlib.so"	$*; }
mpi_dosbin()	{ mpi_do "dosbin"		$*; }
mpi_newsbin()	{ mpi_do "newsbin"		$*; }
mpi_doman()		{ mpi_do "doman"		$*; }
mpi_newman()	{ mpi_do "newman"		$*; }
mpi_doinfo()	{ mpi_do "doinfo"		$*; }
mpi_dodir()		{ mpi_do "dodir"		$*; }
mpi_dohard()	{ mpi_do "dohard"		$*; }
mpi_doins()		{ mpi_do "doins"		$*; }
mpi_dosym()		{ mpi_do "dosym"		$*; }

EXPORT_FUNCTIONS src_compile src_install pkg_setup
