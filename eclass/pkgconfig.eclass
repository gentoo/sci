# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: pkgconfig.eclass
# @MAINTAINER:
# jlec@gentoo.org
# @BLURB: Simplify creation of pkg-config files
# @DESCRIPTION:
# Use this if you buildsystem doesn't create pkg-config files.

inherit multilib

# @ECLASS-VARIABLE: PC_PREFIX
# @REQUIRED
# @DESCRIPTION:
# Offset for current package
: ${PC_PREFIX:="${EPREFIX}/usr"}

# @ECLASS-VARIABLE: PC_EXEC_PREFIX
# @REQUIRED
# @DESCRIPTION:
# Offset for current package
: ${PC_EXEC_PREFIX:="${PC_PREFIX}"}

# @ECLASS-VARIABLE: PC_LIBDIR
# @DESCRIPTION:
# libdir to use
: ${PC_LIBDIR:="${EPREFIX}/usr/$(get_libdir)"}

# @ECLASS-VARIABLE: PC_INCLUDEDIR
# @DESCRIPTION:
# include dir to use
: ${PC_INCLUDEDIR:="${PC_PREFIX}/include"}

# @ECLASS-VARIABLE: PC_NAME
# @DESCRIPTION:
# A human-readable name for the library or package
: ${PC_NAME:=${PN}}

# @ECLASS-VARIABLE: PC_DESCRIPTION
# @DESCRIPTION:
# A brief description of the package
: ${PC_DESCRIPTION:=${DESCRIPTION}}

# @ECLASS-VARIABLE: PC_URL
# @DESCRIPTION:
# An URL where people can get more information about and download the package
: ${PC_URL:=${HOMEPAGE}}

# @ECLASS-VARIABLE: PC_VERSION
# @DESCRIPTION:
# A string specifically defining the version of the package
: ${PC_VERSION:=${PV}}

# @ECLASS-VARIABLE: PC_REQUIRES
# @DEFAULT_UNSET
# @DESCRIPTION:
# A list of packages required by this package. The versions of these packages
# may be specified using the comparison operators =, <, >, <= or >=.

# @ECLASS-VARIABLE: PC_REQUIRES_PRIVATE
# @DEFAULT_UNSET
# @DESCRIPTION:
# A list of private packages required by this package but not exposed to
# applications. The version specific rules from the PC_REQUIRES field also
# apply here.

# @ECLASS-VARIABLE: PC_CONFLICTS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An optional field describing packages that this one conflicts with.
# The version specific rules from the PC_REQUIRES field also apply here.
# This field also takes multiple instances of the same package. E.g.,
# Conflicts: bar < 1.2.3, bar >= 1.3.0.

# @ECLASS-VARIABLE: PC_LIBS
# @DEFAULT_UNSET
# @DESCRIPTION:
# The link flags specific to this package and any required libraries that
# don't support pkg-config. The same rule as PC_CFLAGS applies here.

# @ECLASS-VARIABLE: PC_LIBS_PRIVATE
# @DEFAULT_UNSET
# @DESCRIPTION:
# The link flags for private libraries required by this package but not
# exposed to applications. The same rule as PC_CFLAGS applies here.

# @ECLASS-VARIABLE: PC_CFLAGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# The compiler flags specific to this package and any required libraries
# that don't support pkg-config. If the required libraries support
# pkg-config, they should be added to PC_REQUIRES or PC_REQUIRES_PRIVATE.

# @FUNCTION: create_pkgconfig
# @USAGE: [-p | --prefix PC_PREFIX] [-e | --exec-prefix PC_EXEC_PREFIX] [-L | --libdir PC_LIBDIR ] [-I | --includedir PC_INCLUDEDIR ] [-n | --name PC_NAME] [-d | --description PC_DESCRIPTION] [-V | --version PC_VERSION] [-u | --url PC_URL] [-r | --requires PC_REQUIRES] [--requires-private PC_REQUIRES_PRIVATE] [--conflicts PC_CONFLICTS] [-l | --libs PC_LIBS] [--libs-private PC_LIBS_PRIVATE] [-c | --cflags PC_CFLAGS] <filename>
# @DESCRIPTION:
# Creates and installs .pc file. Function arguments overrule the global set
# eclass variables. The function should only be executed in src_install().
create_pkgconfig() {
	local pcname

	[[ "${EBUILD_PHASE}" != "install" ]] && \
		die "create_pkgconfig should only be used in src_install()"

	while (($#)); do
		case ${1} in
			-p | --prefix )
				shift; PC_PREFIX=${1} ;;
			-e | --exec-prefix )
				shift; PC_EXEC_PREFIX=${1} ;;
			-L | --libdir )
				shift; PC_LIBDIR=${1} ;;
			-I | --includedir )
				shift; PC_INCLUDEDIR=${1} ;;
			-n | --name )
				shift; PC_NAME=${1} ;;
			-d | --description )
				shift; PC_DESCRIPTION=${1} ;;
			-V | --version )
				shift; PC_VERSION=${1} ;;
			-u | --url )
				shift; PC_URL=${1} ;;
			-r | --requires )
				shift; PC_REQUIRES=${1} ;;
			--requires-private )
				shift; PC_REQUIRES_PRIVATE=${1} ;;
			--conflicts )
				shift; PC_CONFLICTS=${1};;
			-l | --libs )
				shift; PC_LIBS=${1} ;;
			--libs-private )
				shift; PC_LIBS_PRIVATE=${1} ;;
			-c | --cflags )
				shift; PC_CFLAGS=${1} ;;
			-* )
				ewarn "Unknown option ${1}" ;;
			* )
				pcname=${1} ;;
		esac
		shift
	done

	[[ -z ${pcname} ]] && die "Missing name for pkg-config file"
	: ${PC_PREFIX:="${EPREFIX}/usr"}
	: ${PC_EXEC_PREFIX:="${PC_PREFIX}"}
	: ${PC_LIBDIR:="${EPREFIX}/usr/$(get_libdir)"}
	: ${PC_INCLUDEDIR:="${PC_PREFIX}/include"}
	: ${PC_NAME:=${PN}}
	: ${PC_DESCRIPTION:=${DESCRIPTION}}
	: ${PC_URL:=${HOMEPAGE}}
	: ${PC_VERSION:=${PV}}

	cat > "${T}"/${pcname}.pc <<- EOF
	prefix="${PC_PREFIX}"
	exec_prefix="${PC_EXEC_PREFIX}"
	libdir="${PC_LIBDIR}"
	includedir="${PC_INCLUDEDIR}"

	Name: ${PC_NAME}
	Description: ${PC_DESCRIPTION}
	Version: ${PC_VERSION}
	URL: ${PC_URL}
	Requires: ${PC_REQUIRES}
	Requires.private: ${PC_REQUIRES_PRIVATE}
	Conflicts: ${PC_CONFLICTS}
	Cflags: ${PC_CFLAGS}
	Libs: ${PC_LIBS}
	Libs.private: ${PC_LIBS_PRIVATE}
	EOF

	insinto /usr/$(get_libdir)/pkgconfig
	doins "${T}"/${pcname}.pc
}
