# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit git-r3 toolchain-funcs python-any-r1

DESCRIPTION="Intel SPMD Program Compiler"
HOMEPAGE="http://ispc.github.com/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/ispc/ispc.git"

LICENSE="BSD BSD-2 UoI-NCSA"
SLOT="0"
IUSE="examples"
KEYWORDS=""

RDEPEND="
	>=sys-devel/clang-3.0
	>=sys-devel/llvm-3.0
	"
DEPEND="
	${RDEPEND}
	${PYTHON_DEPS}
	sys-devel/bison
	sys-devel/flex
	"

src_compile() {
	emake LDFLAGS="${LDFLAGS}" OPT="${CXXFLAGS}" CXX="$(tc-getCXX)" CPP="$(tc-getCPP)"
}

src_install() {
	dobin ispc
	dodoc README.rst

	if use examples; then
		insinto "/usr/share/doc/${PF}/examples"
		docompress -x "/usr/share/doc/${PF}/examples"
		doins -r examples/*
	fi
}
