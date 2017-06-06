# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: numeric.eclass
# @MAINTAINER:
# jlec@gentoo.org
# @BLURB: Maintance bits needed for *lapack* and *blas* packages
# @DESCRIPTION:
# Various functions which make the maintenance  numerical algebra packages
# easier.

if [[ ! ${_NUMERIC_ECLASS} ]]; then

case ${EAPI:-0} in
	0|1|2|3|4|5)
		inherit multilib ;;
	6) ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

# @VARIABLE: NUMERIC_MODULE_NAME
# @DESCRIPTION:
# The base pkg-config module name of the package being built.
# NUMERIC_MODULE_NAME is used by the numeric-int64_get_module_name to
# determine the pkg-config module name based on whether the package
# has dynamic, threads or openmp USE flags and if so, if the user has
# turned them or, and if the current multibuild is a int64 build or not.
#
# @CODE
# NUMERIC_MODULE_NAME="openblas"
# inherit ... numeric-int64-multibuild
# @CODE
: ${NUMERIC_MODULE_NAME:=blas}

# @FUNCTION: create_pkgconfig
# @USAGE: [ additional arguments ]
# @DESCRIPTION:
# Creates and installs pkg-config file. The function should only be executed in
# src_install(). For further information about optional arguments please consult
# http://people.freedesktop.org/~dbn/pkg-config-guide.html
#
# @CODE
# Optional arguments are:
#
#   -p | --prefix       Offset for current package               (${EPREFIX}/usr)
#   -e | --exec-prefix  Offset for current package               (${prefix})
#   -L | --libdir       Libdir to use                            (${prefix}/$(get_libdir))
#   -I | --includedir   Includedir to use                        (${prefix}/include)
#   -n | --name         A human-readable name                    (PN}
#   -d | --description  A brief description                      (DESCRIPTION)
#   -V | --version      Version of the package                   (PV)
#   -u | --url          Web presents                             (HOMEPAGE)
#   -r | --requires     Packages required by this package        (unset)
#   -l | --libs         Link flags specific to this package      (unset)
#   -c | --cflags       Compiler flags specific to this package  (unset)
#   --requires-private  Like --requires, but not exposed         (unset)
#   --conflicts         Packages that this one conflicts with    (unset)
#   --libs-private      Like --libs, but not exposed             (unset)
# @CODE
create_pkgconfig() {
	debug-print-function ${FUNCNAME} "${@}"
	local pcfilename pcrequires pcrequirespriv pcconflicts pclibs pclibspriv pccflags
	local pcprefix="${EPREFIX}/usr"
	local pcexecprefix="${pcprefix}"
	local pclibdir="${EPREFIX}/usr/$(get_libdir)"
	local pcincldir="${pcprefix}/include"
	local pcname=${PN}
	local pcdescription="${DESCRIPTION}"
	local pcurl=${HOMEPAGE}
	local pcversion=${PV}

	[[ "${EBUILD_PHASE}" != "install" ]] && \
		die "create_pkgconfig should only be used in src_install()"

	while (($#)); do
		case ${1} in
			-p | --prefix )
				shift; pcprefix=${1} ;;
			-e | --exec-prefix )
				shift; pcexecprefix=${1} ;;
			-L | --libdir )
				shift; pclibdir=${1} ;;
			-I | --includedir )
				shift; pcincldir=${1} ;;
			-n | --name )
				shift; pcname=${1} ;;
			-d | --description )
				shift; pcdescription=${1} ;;
			-V | --version )
				shift; pcversion=${1} ;;
			-u | --url )
				shift; pcurl=${1} ;;
			-r | --requires )
				shift; pcrequires=${1} ;;
			--requires-private )
				shift; pcrequirespriv=${1} ;;
			--conflicts )
				shift; pcconflicts=${1};;
			-l | --libs )
				shift; pclibs=${1} ;;
			--libs-private )
				shift; pclibspriv=${1} ;;
			-c | --cflags )
				shift; pccflags=${1} ;;
			-* )
				ewarn "Unknown option ${1}" ;;
			* )
				pcfilename=${1} ;;
		esac
		shift
	done

	[[ -z ${pcfilename} ]] && die "Missing name for pkg-config file"

	cat > "${T}"/${pcfilename}.pc <<- EOF
	prefix="${pcprefix}"
	exec_prefix="${pcexecprefix}"
	libdir="${pclibdir}"
	includedir="${pcincldir}"

	Name: ${pcname}
	Description: ${pcdescription}
	Version: ${pcversion}
	URL: ${pcurl}
	Requires: ${pcrequires}
	Requires.private: ${pcrequirespriv}
	Conflicts: ${pcconflicts}
	Libs: -L\${libdir} ${pclibs}
	Libs.private: ${pclibspriv}
	Cflags: -I\${includedir} ${pccflags}
	EOF

	insinto /usr/$(get_libdir)/pkgconfig
	doins "${T}"/${pcfilename}.pc
}

_NUMERIC_ECLASS=1
fi
