# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 cmake

DESCRIPTION="Fast and sensitive sequence search and clustering"
HOMEPAGE="https://github.com/soedinglab/MMseqs2"
MY_PN="MMseqs2"
SUB_PV="45111" # this is a hex value and must be updated with each release
MY_PV="${PV}-${SUB_PV}"

SRC_URI="https://github.com/soedinglab/${MY_PN}/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

# This package only builds correctly native and does not respect
# CPU flags, despite a subset of them being defined as cmake flags.

# Need static libs per https://github.com/soedinglab/MMseqs2/issues/411
DEPEND="
	sys-libs/zlib[static-libs]
	app-arch/bzip2[static-libs]
	app-arch/zstd[static-libs]
"
DEPEND="${RDEPEND}
	app-shells/bash-completion
"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

src_configure() {
        local mycmakeargs=(
                -DBUILD_SHARED_LIBS=OFF
                -DUSE_SYSTEM_ZSTD=ON
                -DVERSION_OVERRIDE=${MY_PV}
        )
        cmake_src_configure
}

src_install(){
	cmake_src_install
	newbashcomp "${ED}/usr/util/bash-completion.sh" mmseqs
	rm -r "${ED}/usr/util/" || die
}
