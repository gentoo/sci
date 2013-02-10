# Copyright 2013-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

if [ ${PV} == "9999" ] ; then
	_SCM=mercurial
	EHG_REPO_URI="http://bitbucket.org/gentryx/libgeodecomp"
	SRC_URI=""
	KEYWORDS=""
	CMAKE_USE_DIR="${S}/src"
else
	SRC_URI="http://www.libgeodecomp.org/archive/${P}.tar.bz2"
	KEYWORDS="~amd64 ~ppc ~x86"
	S="${WORKDIR}/${P}/src"
fi

inherit cmake-utils ${_SCM}

DESCRIPTION="An auto-parallelizing library to speed up computer simulations"
HOMEPAGE="http://www.libgeodecomp.org"

SLOT="0"
LICENSE="LGPL-3"
IUSE="doc"

RDEPEND=">=dev-libs/boost-1.48"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_compile() {
	cmake-utils_src_compile
	use doc && cmake-utils_src_make doc
}

src_install() {
	DOCS=( README )
	use doc && HTML_DOCS=( doc/html/* )
	cmake-utils_src_install
}

src_test() {
	cmake-utils_src_make test
}