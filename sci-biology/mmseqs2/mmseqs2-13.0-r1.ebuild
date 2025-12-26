# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 cmake

MY_PN="MMseqs2"

# Must be manually updated with each release
COMMIT="45111b641859ed0ddd875b94d6fd1aef1a675b7e"

DESCRIPTION="Fast and sensitive sequence search and clustering"
HOMEPAGE="https://github.com/soedinglab/MMseqs2"
SRC_URI="https://github.com/soedinglab/${MY_PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cpu_flags_x86_sse4_1 cpu_flags_x86_sse2 cpu_flags_x86_avx2"

RDEPEND="
	app-arch/zstd[static-libs]
	virtual/zlib:=
	app-arch/bzip2
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-properly-handle-cpuflags.patch"
)

src_configure() {
	local mycmakeargs=(
		# Need static libs: https://github.com/soedinglab/MMseqs2/issues/411
		-DBUILD_SHARED_LIBS=OFF
		-DUSE_SYSTEM_ZSTD=ON
		# Disable auto detection, build respecting cpu flags instead
		-DNATIVE_ARCH=OFF
		-DHAVE_AVX2="$(usex cpu_flags_x86_avx2)"
		-DHAVE_SSE4_1="$(usex cpu_flags_x86_sse4_1)"
		-DHAVE_SSE2="$(usex cpu_flags_x86_sse2)"
		# We also have cpu flags for ppc/arm/s390x
		-DVERSION_OVERRIDE=${PV}
	)
	cmake_src_configure
}

src_install(){
	cmake_src_install
	# move the bashcomp to correct dir
	newbashcomp "${ED}/usr/util/bash-completion.sh" "${PN}"
	rm -r "${ED}/usr/util/" || die
}
