# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Tools for people envious of nvidia's blob driver"
HOMEPAGE="https://envytools.readthedocs.io/en/latest/"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/envytools/envytools"
else
	COMMIT="2d9931313aa14dfdf26f85be2576b181a14ad387"
	SRC_URI="https://github.com/envytools/envytools/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${COMMIT}
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="
	dev-libs/libxml2
	x11-libs/libpciaccess
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	sys-devel/bison
	sys-devel/flex
"

DOCS=( README.rst )

PATCHES=( "${FILESDIR}"/${PN}-bison.patch )
