# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils cmake-utils

DESCRIPTION="A header-only C++ Computing Library for OpenCL"
HOMEPAGE="https://github.com/boostorg/compute"
SRC_URI="https://github.com/boostorg/compute/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-libs/boost
	virtual/opencl
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/compute-${PV}"
