# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools-utils fortran-2 multibuild

DESCRIPTION="Parallel 3d FFT"
HOMEPAGE="https://www-user.tu-chemnitz.de/~potts/workgroup/pippig/software.php.en"

if [[ $PV = *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mpip/pfft.git"
	KEYWORDS=""
	AUTOTOOLS_AUTORECONF=1
else
	SRC_URI="https://www-user.tu-chemnitz.de/~potts/workgroup/pippig/software/${P//_/-}.tar.gz"
	KEYWORDS="~x86 ~amd64"
	S="${WORKDIR}/${P//_/-}"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="static-libs"

RDEPEND="
	sci-libs/fftw:3.0[mpi,fortran]
	virtual/mpi
	"

DEPEND="
	${RDEPEND}
	"

src_configure() {
	MULTIBUILD_VARIANTS=( single double long-double )
	my_src_configure() {
		local myeconfargs=(
			$([[ ${MULTIBUILD_VARIANT} != double ]] && echo "--enable-${MULTIBUILD_VARIANT}")
		)
		autotools-utils_src_configure
	}

	multibuild_parallel_foreach_variant my_src_configure
}

src_compile() {
	multibuild_foreach_variant autotools-utils_src_compile
}

src_install() {
	multibuild_parallel_foreach_variant autotools-utils_src_install
}
