# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 )
DISTUTILS_OPTIONAL=1
inherit distutils-r1

DESCRIPTION="splice-aware sequence aligner with SSE2 and SSE4.1"
HOMEPAGE="https://github.com/lh3/minimap2"
SRC_URI="https://github.com/lh3/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python cpu_flags_x86_sse4_1"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="sys-libs/zlib
	python? (
		${PYTHON_DEPS}
	)"
RDEPEND="${DEPEND}"
BDEPEND="python? ( dev-python/cython[${PYTHON_USEDEP}] )"

src_prepare(){
	sed -e 's/-O2 //' -e 's/^CFLAGS=/CFLAGS+=/' -i Makefile || die
	if ! use cpu_flags_x86_sse4_1; then
		sed -i -e "/extra_compile_args.append('-msse4.1')/d" setup.py || die
	fi
	if use python; then
		distutils-r1_src_prepare
	fi
	default
}

src_configure() {
	if use python; then
		distutils-r1_src_configure
	fi
	default
}

src_compile() {
	if use python; then
		distutils-r1_src_compile
	fi
	default
}

src_install() {
	if use python; then
		distutils-r1_src_install
	fi
	dobin "${PN}"
	insinto /usr/include
	doins minimap.h mmpriv.h
	insinto /usr/share/"${PN}"/examples
	doins example.c
	doman minimap2.1
	einstalldocs
}
