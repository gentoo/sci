# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils llvm

MY_PN="CastXML"

DESCRIPTION="CastXML is a C-family abstract syntax tree XML output tool."
HOMEPAGE="https://github.com/CastXML/CastXML"
SRC_URI="https://github.com/CastXML/CastXML/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="${RDEPEND}"
RDEPEND="
		dev-libs/glib:2
		dev-libs/libxml2
		sys-devel/llvm:=
		sys-devel/clang:=
		"

S="${WORKDIR}/${MY_PN}-${PV}"

src_test() {
	cd "${BUILD_DIR}" || die
	ctest -j 20
}
