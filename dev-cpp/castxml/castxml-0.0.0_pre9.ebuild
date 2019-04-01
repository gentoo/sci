# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3 llvm

MY_PN="CastXML"

DESCRIPTION="CastXML is a C-family abstract syntax tree XML output tool."
HOMEPAGE="https://github.com/CastXML/CastXML"
SRC_URI=""
EGIT_REPO_URI="https://github.com/gerddie/CastXML"
EGIT_COMMIT="6b3d3f985f4607430d0e7ecd835ee80b29f3ae96"

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

src_test() {
	cd "${BUILD_DIR}" || die
	ctest -j 20
}
