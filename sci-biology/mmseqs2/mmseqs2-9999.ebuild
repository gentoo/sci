# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 cmake git-r3

DESCRIPTION="Fast and sensitive sequence search and clustering"
HOMEPAGE="https://github.com/soedinglab/MMseqs2"
MY_PN="MMseqs2"
EGIT_REPO_URI="https://github.com/soedinglab/MMseqs2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="cpu_flags_x86_sse4_1 cpu_flags_x86_sse2 cpu_flags_x86_avx2"

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
		# Live version will be built native
	)
	cmake_src_configure
}

src_install(){
	cmake_src_install
	newbashcomp "${ED}/usr/util/bash-completion.sh" mmseqs
	rm -r "${ED}/usr/util/" || die
}
