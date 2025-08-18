# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake fortran-2 flag-o-matic

DESCRIPTION="CERN program library for High Energy Physics"
HOMEPAGE="https://cernlib.web.cern.ch/cernlib/"
SRC_URI="
	free? ( https://cernlib.web.cern.ch/download/2023_source/tar/${P}-free.tar.gz )
	!free? ( https://cernlib.web.cern.ch/download/2023_source/tar/${P}.tar.gz )
"

LICENSE="
	free? ( BSD LGPL-2+ GPL-1+ )
	!free? ( all-rights-reserved )
"
SLOT="0"
KEYWORDS="~amd64"
# static-libs as default since otherwise test fail...
IUSE="+free +static-libs"
RESTRICT="mirror"

RDEPEND="
	x11-libs/motif:0
	x11-libs/libXaw
	x11-libs/libXau
	virtual/lapack
	dev-lang/cfortran
	x11-libs/xbae
	net-libs/libnsl
	virtual/libcrypt:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-cfortran.patch
	"${FILESDIR}"/${P}-ctest.patch
	"${FILESDIR}"/${P}-man.patch
)

src_unpack() {
	default
	if use free; then
		mv ${P}-free ${P} || die
	fi
}

src_prepare() {
	cmake_src_prepare
	# cfortran.patch
	# Remove cfortran.h since it is already installed from dev-lang/cfortran
	# thereby we avoid collisions if e.g. sci-physics/root[fortran] is installed.
	rm cfortran/cfortran.h || die
}

src_configure() {
	# docs follow rpm like spliting into packages cernlib, cernlib-devel, etc.
	# we move them into a folder that agrees with gentoo doc structure.
	sed -i "s#/doc/#/doc/${PF}/#g" CMakeLists.txt || die
	# with -O2 some tests fail
	# let upstream decide on optimization (-O0) since code is fragile
	filter-flags -O1 -O2 -O3 -Os -Oz -Og -Ofast
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex static-libs OFF ON)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	# man.patch
	# The CMakeLists.txt already compresses the manual before install
	# therefore we install it manually and avoid QA problems.
	doman contrib/man/man1/*.1
	doman contrib/man/man8/*.8
}
