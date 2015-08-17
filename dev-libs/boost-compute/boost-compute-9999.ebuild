# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils cmake-utils

DESCRIPTION="A header-only C++ Computing Library for OpenCL"
HOMEPAGE="https://github.com/boostorg/compute"

LICENSE="Boost-1.0"
SLOT="0"
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/boostorg/compute.git git://github.com/boostorg/compute.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/boostorg/compute/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/compute-${PV}"
fi

RDEPEND="
	dev-libs/boost
	virtual/opencl
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}"-0.4-CMakeLists.patch
)
