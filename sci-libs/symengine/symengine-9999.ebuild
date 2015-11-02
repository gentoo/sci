# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3 cmake-utils

DESCRIPTION="Fast symbolic manipulation library, written in C++"
HOMEPAGE="https://github.com/sympy/symengine"
SRC_URI=""
EGIT_REPO_URI="https://github.com/sympy/symengine.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="boost openmp threads"
REQUIRED_USE="?? ( openmp threads )"

RDEPEND="
	dev-libs/jemalloc
	boost? ( dev-libs/boost )"
DEPEND="${RDEPEND}"

CMAKE_BUILD_TYPE=Release

pkg_pretend() {
	if use openmp && [[ ${MERGE_TYPE} != binary ]]; then
		if [[ $(tc-getCC) == *gcc ]] && ! tc-has-openmp; then
			ewarn "OpenMP is not available in your current selected gcc"
			die "need openmp capable gcc"
		fi
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX:PATH="${EPREFIX}"/usr
		$(cmake-utils_use_with boost)
		$(cmake-utils_use_with openmp)
	)

	if use threads; then
		mycmakeargs+=(
			-DWITH_TCMALLOC:BOOL=ON
			-DWITH_PTHREAD:BOOL=ON
			-DWITH_SYMENGINE_THREAD_SAFE:BOOL=ON
		)
	fi

	cmake-utils_src_configure
}
