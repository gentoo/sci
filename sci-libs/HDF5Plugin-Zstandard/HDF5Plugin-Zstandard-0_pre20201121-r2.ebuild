# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="ZSTD plugin for hdf5"
HOMEPAGE="https://github.com/aparamon/HDF5Plugin-Zstandard"
COMMIT="d5afdb5f04116d5c2d1a869dc9c7c0c72832b143"
SRC_URI="https://github.com/aparamon/HDF5Plugin-Zstandard/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/zstd >=sci-libs/hdf5-1.12.2-r5"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}-${COMMIT}

src_configure() {
	local mycmakeargs=(
		-DPLUGIN_INSTALL_PATH="${EPREFIX}/usr/$(get_libdir)/hdf5/plugin"
	)
	cmake_src_configure
}
