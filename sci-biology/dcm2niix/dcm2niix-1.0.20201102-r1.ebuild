# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake optfeature

DESCRIPTION="DICOM to NIfTI converter"
HOMEPAGE="https://github.com/rordenlab/dcm2niix"
SRC_URI="https://github.com/rordenlab/dcm2niix/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE="static system-jpeg +jpeg-ls jpeg2k"

DEPEND="
	system-jpeg? ( media-libs/libjpeg-turbo )
	jpeg2k? ( media-libs/openjpeg )
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-disable_find_git.patch
)

src_configure() {
	local mycmakeargs=(
		-DUSE_STATIC_RUNTIME=$(usex static)
		-DUSE_TURBOJPEG=$(usex system-jpeg)
		-DUSE_JPEGLS=$(usex jpeg-ls)
		-DUSE_OPENJPEG=$(usex jpeg2k)
	)

	cmake_src_configure
}

pkg_postinst() {
	optfeature "parallel gzip support" app-arch/pigz
}
