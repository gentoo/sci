# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit versionator

RELEASE="$(get_version_component_range 1-2)"
BUILD="$(get_version_component_range 3)"

DESCRIPTION="Intel C/C++/FORTRAN debugger for Linux"
HOMEPAGE="http://www.intel.com/software/products/compilers/"
SRC_URI=""

KEYWORDS="~amd64 ~ia64 ~x86"

LICENSE="Intel-SDP"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="|| ( ~dev-lang/icc-${PV}[idb] ~dev-lang/ifc-${PV}[idb] )
	>=virtual/jre-1.5"

DESTINATION="${ROOT}opt/intel/Compiler/${RELEASE}/${BUILD}"

src_install() {
	cat > 06idb <<-EOF
		NLSPATH=${DESTINATION}/idb/${IARCH}/locale/%l_%t/%N
	EOF
	doenvd 06idb || die "doenvd 06idb failed"
}
