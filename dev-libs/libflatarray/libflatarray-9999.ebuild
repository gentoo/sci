# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils cuda mercurial

DESCRIPTION="Struct of arrays library with object oriented interface for C++"
HOMEPAGE="http://www.libgeodecomp.org/libflatarray.html"
SRC_URI=""
EHG_REPO_URI="http://bitbucket.org/gentryx/libflatarray"

SLOT="0"
LICENSE="Boost-1.0"
KEYWORDS=""
IUSE="cuda doc"

RDEPEND="
	>=dev-libs/boost-1.48
	cuda? ( dev-util/nvidia-cuda-toolkit )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

CMAKE_USE_DIR="${S}"
DOCS=( README )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with cuda CUDA)
	)
	cmake-utils_src_configure
}
