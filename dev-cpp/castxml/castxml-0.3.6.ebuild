# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake llvm

MY_PN="CastXML"

DESCRIPTION="CastXML is a C-family abstract syntax tree XML output tool."
HOMEPAGE="https://github.com/CastXML/CastXML"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/CastXML/CastXML"
else
	SRC_URI="https://github.com/CastXML/CastXML/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="${RDEPEND}"
RDEPEND="
	dev-libs/glib:2
	dev-libs/libxml2
	sys-devel/llvm:=
	sys-devel/clang:=
"

S="${WORKDIR}/${MY_PN}-${PV}"

PATCHES=( "${FILESDIR}"/${PN}-0.3.6-install-paths.patch )
