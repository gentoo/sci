# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )
# https://github.com/Ensembl/Bio-DB-HTS/issues/30

inherit flag-o-matic autotools distutils-r1

DESCRIPTION="K-mer Analysis Toolkit (histogram, filter, compare sets, plot)"
HOMEPAGE="https://github.com/TGAC/KAT"
SRC_URI="https://github.com/TGAC/KAT/archive/Release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse static-libs test"

CDEPEND="
	>=dev-libs/boost-1.52[${PYTHON_USEDEP}]
	sys-libs/zlib
	dev-python/tabulate[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}
	dev-python/sphinx
	test? ( sys-process/time )"
RDEPEND="${CDEPEND}"
# contains bundled and *modified* version of jellyfish-2.2.0
#   (libkat_jellyfish.{a,so} and "kat_" prefixes are added to all binaries)
#   https://github.com/TGAC/KAT/issues/93#issuecomment-383377666
# contains embedded sci-biology/seqan headers

PATCHES=(
	"${FILESDIR}"/kat-2.4.2-ignore-bundled-deps.patch
	"${FILESDIR}"/kat-2.4.2-no_static_build.patch
	)

S="${WORKDIR}"/KAT-Release-"${PV}"

src_prepare(){
	default
	rm -rf deps/boost || die "Failed to zap bundled boost"
	eautoreconf
}

src_configure(){
	python_setup
	local myconf=()
	myconf+=(
		--disable-gnuplot
		--disable-pykat-install
		$(use_enable static-libs static)
		) # python3 does better image rendering, no need for gnuplot
	# pass down to jellyfish-2.2.0/configure
	use cpu_flags_x86_sse && myconf+=( $(use_with cpu_flags_x86_sse sse) )
	econf ${myconf[@]}
}

src_compile(){
	default
	pushd scripts >/dev/null || die
	distutils-r1_src_compile
	popd > /dev/null || die
}

src_install(){
	default
	pushd scripts >/dev/null || die
	distutils-r1_src_install
	popd > /dev/null || die
}

src_test(){
	default
}
