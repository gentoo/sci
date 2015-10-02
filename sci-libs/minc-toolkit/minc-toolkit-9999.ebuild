#DUS Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit cmake-utils git-r3

DESCRIPTION="Metaproject uniting all the available MINC tools"
HOMEPAGE="https://github.com/BIC-MNI/minc-toolkit"
SRC_URI=""
EGIT_REPO_URI="git://github.com/BIC-MNI/minc-toolkit.git"

LICENSE="BSD"
SLOT="0"
IUSE="itk"
KEYWORDS=""

COMMON_DEP="dev-libs/libpcre
	sci-libs/fftw:3.0
	sci-libs/gsl
	sci-libs/hdf5
	itk? ( sci-libs/itk )
	media-libs/freeglut
	x11-libs/libXmu
	x11-libs/libXi"

DEPEND="dev-lang/perl
	sys-libs/zlib
	sys-devel/bison
	sys-devel/flex
	${COMMON_DEP}"

RDEPEND="sci-libs/netcdf
	${COMMON_DEP}"

src_configure() {
	local mycmakeargs=(
		cmake-utils_use_use itk SYSTEM_ITK
		-DUSE_SYSTEM_FFTW3F=1
		-DUSE_SYSTEM_GSL=1
		-DUSE_SYSTEM_HDF5=1
		-DUSE_SYSTEM_NETCDF=1
		-DUSE_SYSTEM_PCRE=1
		-DUSE_SYSTEM_ZLIB=1
		-DMT_BUILD_ITK_TOOL=$(usex itk 1 0)
		)
	cmake-utils_src_configure
}
