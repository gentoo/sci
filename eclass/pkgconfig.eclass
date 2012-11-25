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

# @ECLAS-VARIABLE: PC_NAME
# @DESCRIPTION:
# Name of pkg-config file, defaults to PN
: {PC_NAME:-${PN}}

# @ECLAS-VARIABLE: PC_LIBDIR
# @DESCRIPTION:
# libdir to use, default to standard system libdir aka /usr/lib*
: {PC_LIBDIR:-""}

# @ECLASS_FUNCTION: create_pkgconfig
# @DESCRIPTION:
create_pkgconfig() {
[[ -z ${PC_LIBDIR]] || PC_LIBDIR="${EPREFIX}/usr/$(get_libdir)"

cat > ${T}/${pcname}.pc
prefix=${EPREFIX}/usr
libdir=\${prefix}/$(get_libdir)
includedir=\${prefix}/include
Name: ${pcname}
Description: ${PN} ${pcname}
Version: ${PV}
URL: ${HOMEPAGE}
Libs: -L\${libdir} -l${libname} $@
Cflags: -I\${includedir}/${PN}
${PCREQ}
EOF

}