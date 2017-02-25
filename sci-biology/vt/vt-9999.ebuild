# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3 toolchain-funcs

DESCRIPTION="A tool set for short variant discovery in genetic sequence data"
HOMEPAGE="https://github.com/atks/vt
	http://genome.sph.umich.edu/wiki/vt"
EGIT_REPO_URI="https://github.com/atks/vt.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="pdf"

DEPEND=""
RDEPEND="${DEPEND}
	pdf? ( dev-texlive/texlive-latex || ( dev-texlive/texlive-basic ) )"
#	>=sci-libs/htslib-1.3.2
#	dev-cpp/tclap
#	sci-libs/libsvm
#	dev-libs/libpcre
#	https://github.com/atks/Rmath

# The 3rd party stuff is bundled because they have special modifications that
# I made for vt, so it is probably not a good idea to depend on installed components.
# For example TCLAP is modified partially, libsvm has some minor input/output format changes,
# Rmath has the header inclusion to always generate the .a object file

# Compiles statically bundled version of htslib and Rmath, only libpcre2 is dynamically linked
src_prepare(){
	sed -e "s/= -O3/= ${CFLAGS}/" -i Makefile || die
	sed -e 's/^CXX = /CXX ?= /' -i Makefile || die
	sed -e "s/-g -Wall -O2/${CFLAGS}/" -i lib/htslib/Makefile || die
	sed -e "s/= gcc/= $(tc-getCC)/" -i lib/htslib/Makefile || die
	sed -e "s/gcc -g -O3/$(tc-getCC) ${CFLAGS}/" -i lib/pcre2/Makefile || die
	sed -e "s/-Wall -O3 -fPIC/${CXXFLAGS} -fPIC/" -i lib/libsvm/Makefile || die
#	# TODO zap bundled version of:
#	# 	lib/htslib  (version 1.3)
#	#	lib/tclap
#	#	lib/Rmath
#	#	lib/libsvm
#	#	lib/pcre2
}

src_install(){
	dobin vt
}
