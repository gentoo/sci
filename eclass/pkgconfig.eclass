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
:{PC_PREFIX:-"${EPREFIX}/usr"}

# @ECLASS-VARIABLE: PC_EXEC_PREFIX
# @REQUIRED
# @DESCRIPTION:
# Offset for current package
:{PC_EXEC_PREFIX:-"${PC_PREFIX}"}

# @ECLASS-VARIABLE: PC_LIBDIR
# @DESCRIPTION:
# libdir to use, defaults to standard system libdir aka /usr/lib*

# @ECLASS-VARIABLE: PC_INCLUDEDIR
# @DESCRIPTION:
# include dir to use, defaults to standard system libdir aka /usr/include
:{PC_INCLUDEDIR:-"${PC_PREFIX}/include"}

# A human-readable name for the library or package, defaults to PN
: {PC_NAME:-${PN}}

# @ECLASS-VARIABLE: PC_DESCRIPTION
# @DESCRIPTION:
# A brief description of the package, defaults to DESCRIPTION
:{PC_DESCRIPTION:-DESCRIPTION}

# @ECLASS-VARIABLE: PC_URL
# @DESCRIPTION:
# An URL where people can get more information about and download the package,
# defaults to HOMEPAGE
:{PC_URL:-HOMEPAGE}

# @ECLASS-VARIABLE: PC_VERSION
# @DESCRIPTION:
# A string specifically defining the version of the package, defaults to ${PV}
:{PC_VERSION:-PV}

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

# @ECLASS-VARIABLE: PC_CONFLICT
# @DEFAULT_UNSET
# @DESCRIPTION:
# An optional field describing packages that this one conflicts with.
# The version specific rules from the PC_REQUIRES field also apply here.
# This field also takes multiple instances of the same package. E.g.,
# Conflicts: bar < 1.2.3, bar >= 1.3.0.

# @ECLASS-VARIABLE: PC_CFLAGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# The compiler flags specific to this package and any required libraries
# that don't support pkg-config. If the required libraries support
# pkg-config, they should be added to PC_REQUIRES or PC_REQUIRES_PRIVATE.

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

# @FUNCTION: create_pkgconfig
# @DESCRIPTION:
create_pkgconfig() {
	local name
	case ${1} in
		-i | --includedir )
			shift
			PC_INCLUDEDIR=${1}
			;;
		-l | --libdir )
			shift
			PC_LIBDIR=${1}
			;;
		-* )
			die "Unknown option ${1}"
		* )
			name=${1}
			;;
	esac

	[[ -z ${name} ]] && die "Missing name for pkg-config file"
	[[ -z ${PC_LIBDIR]] || PC_LIBDIR="${EPREFIX}/usr/$(get_libdir)"

	cat > ${T}/${pcname}.pc <<- EOF
	prefix="${EPREFIX}/usr"
exec_prefix=\${prefix}
libdir=\${prefix}/$(get_libdir)
includedir=\${prefix}/include

Name: ${pcname}
Description: ${PN} ${pcname}
Version: ${PV}
URL: ${HOMEPAGE}
Requires:
Requires.private:
Conflicts:
Libs.private:
Libs: -L\${libdir} -l${libname} $@
Cflags: -I\${includedir}/${PN}
${PCREQ}
EOF

}
