# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils

DESCRIPTION="C++ Library for reading and writing CIFTI-2 and CIFTI-1 files"
HOMEPAGE="https://github.com/Washington-University/CiftiLib"
SRC_URI="https://github.com/Washington-University/CiftiLib/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt5"

DEPEND="
	dev-libs/boost
	qt5? ( dev-qt/qtcore:5 )
	!qt5? ( dev-cpp/libxmlpp:2.6 )
	sys-libs/zlib
	"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.3-openmp_in_pc.patch
	)

S="${WORKDIR}/CiftiLib-${PV}"

#TODO: Enable doc building and installation

src_prepare(){
	# Make sure that CiftiLib headers and code can
	# coexist with nifti_io headers.
	# This takes care of the guard in the nifti1.h header
	# found in both code base.
	sed \
		-e "s:NIFTI_:CIFTI_NIFTI__:g" \
		-i `grep -rl NIFTI_ *`
	sed \
		-e "s:DT_:CIFTI_DT_:g" \
		-i `grep -rl DT_ *`

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(-DBUILD_SHARED_LIBS=ON)
	use qt5 || mycmakeargs+=(-DIGNORE_QT=TRUE)

	cmake-utils_src_configure
}

src_test(){
	#The testsuite is not designed to run in parallel
	local myctestargs=(
			-j1
	)
	cmake-utils_src_test
}
