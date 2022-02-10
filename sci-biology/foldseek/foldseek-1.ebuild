# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Fast and sensitive comparison of large structure sets"
HOMEPAGE="https://github.com/steineggerlab/foldseek"
# To be consistent with upstream, this must be updated with each release
SUB_PV="3c64211"
MY_PV="${PV}-${SUB_PV}"

SRC_URI="https://github.com/steineggerlab/${PN}/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

# Need static libs per https://github.com/soedinglab/MMseqs2/issues/411
DEPEND="
	sys-libs/zlib[static-libs]
	app-arch/bzip2[static-libs]
	app-arch/zstd[static-libs]
"
DEPEND="${RDEPEND}
	app-shells/bash-completion
"

S="${WORKDIR}/${PN}-${MY_PV}"

src_configure() {
        local mycmakeargs=(
                -DBUILD_SHARED_LIBS=OFF
                -DUSE_SYSTEM_ZSTD=ON
                # In principle, we should be using system cpu flags
                # but cmake flags for SSE, SSE3, and SSE4_2 aren't
                # defined, resulting in no CPU flags getting recognized.
                # Ditto for static bundled mmseqs and gemmi libs.
                -DVERSION_OVERRIDE=${MY_PV}
        )
        cmake_src_configure
}
