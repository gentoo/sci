# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit elisp-common

DESCRIPTION="Intel C/C++/FORTRAN debugger for Linux"
HOMEPAGE="http://www.intel.com/software/products/compilers/"
SRC_URI=""

KEYWORDS="~amd64 ~ia64 ~x86"

LICENSE="Intel-SDP"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="|| ( ~dev-lang/icc-${PV}[idb] ~dev-lang/ifc-${PV}[idb] )"
