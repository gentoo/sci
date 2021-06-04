# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="KING${PV}"
DESCRIPTION="Check family relationship and infer population structure"
HOMEPAGE="https://kingrelatedness.com"
SRC_URI="https://www.kingrelatedness.com/executables/${MY_P}code.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"

LICENSE="all-rights-reserved" # Our robust relationship inference algorithm is implemented in a freely available software package
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile(){
	$(tc-getCXX) ${CXXFLAGS} -lm -lz -fopenmp -o king *.cpp
}

src_install(){
	newbin {king,KING}
}
