# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Fast and sensitive comparison of large structure sets"
HOMEPAGE="https://github.com/steineggerlab/foldseek"
EGIT_REPO_URI="https://github.com/steineggerlab/foldseek"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

# Need static libs per https://github.com/soedinglab/MMseqs2/issues/411
DEPEND="
	sys-libs/zlib[static-libs]
	app-arch/bzip2[static-libs]
	app-arch/zstd[static-libs]
"
DEPEND="${RDEPEND}
	app-shells/bash-completion
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DUSE_SYSTEM_ZSTD=ON
	)
	cmake_src_configure
}
