# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit versionator

if [[ ${PV} == "9999" ]] ; then
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

inherit cmake-utils vcs-snapshot ${_SCM} 

DESCRIPTION="LibGeoDecomp is an auto-parallelizing library to speed up your stencil code based computer simulations. It runs on virtually all current architectures, be it multi-cores, GPUs, or large scale MPI clusters. "
HOMEPAGE="http://www.libgeodecomp.org"

LICENSE="LGPL-3.0"
SLOT="0"
IUSE="doc"

RDEPEND=">=dev-libs/boost-1.48"
DEPEND="${RDEPEND}
        doc? ( app-doc/doxygen )"

src_compile() {
    cmake-utils_src_compile 
    if ( use doc); then 
        cmake-utils_src_compile doc 
    fi
}

src_install() {
    cmake-utils_src_install

    dodoc README
    if ( use doc); then 
        dohtml doc/html/*
    fi
}

src_test() {
    cmake-utils_src_compile test    
}
