# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} ) # requires python >= 3.1 but more features with >=3.5
# https://github.com/Ensembl/Bio-DB-HTS/issues/30

inherit flag-o-matic autotools distutils-r1

DESCRIPTION="K-mer Analysis Toolkit (histogram, filter, compare sets, plot)"
HOMEPAGE="https://github.com/TGAC/KAT"
SRC_URI="https://github.com/TGAC/KAT/archive/Release-2.4.1.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse static-libs test"

CDEPEND="
	>=dev-libs/boost-1.52[${PYTHON_USEDEP}]
	dev-python/tabulate[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}
	dev-python/sphinx[${PYTHON_USEDEP}]
	test? ( sys-process/time )"
RDEPEND="${CDEPEND}"
# contains bundled a *modified* version of jellyfish-2.2.0 (libkat_jellyfish.{a,so})
# contains embedded sci-biology/seqan

PATCHES=(
	"${FILESDIR}"/kat-2.4.1-ignore-bundled-deps.patch
	"${FILESDIR}"/kat-2.4.1-parallel_doc.patch
	)

S="${WORKDIR}"/KAT-Release-"${PV}"

src_prepare(){
	# distutils_src_prepare would also run default. Only include one of them.
	default
	# keep bundled seqan-library-2.0.0 jellyfish-2.2.0
	# seqan header do not hurt
	# jellyfish-2.2.0 is a modified version, "kat_" prefixes are added to all binaries
	# https://github.com/TGAC/KAT/issues/93#issuecomment-383377666
	rm -rf deps/boost || die "Failed to zap bundled boost"
	eautoreconf
}

src_configure(){
	local myconf=()
	myconf+=(
		--disable-gnuplot
		--disable-pykat
		--disable-pykat-install
		$(use_enable static-libs static)
		) # python3 does better image rendering, no need for gnuplot
	use cpu_flags_x86_sse && myconf+=( $(use_with cpu_flags_x86_sse sse) ) # pass down to jellyfish-2.2.0/configure
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
