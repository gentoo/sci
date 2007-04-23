# Copyright 1999-2007 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.3

inherit distutils eutils

MY_P=MayaVi-${PV}
DESCRIPTION="VTK based scientific data visualizer"
HOMEPAGE="http://mayavi.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="2"
KEYWORDS="~amd64 ~x86"

IUSE="doc examples"
DEPEND=">=sci-libs/vtk-5.0.3"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	python_tkinter_exists

	# Does vtk have to be compiled with patented: comment #5 in bug #50464 ?
	if ! built_with_use sci-libs/vtk tk python; then
		eerror "vtk is missing tk or python support."
		eerror "Please ensure you have the 'tk' and 'python' USE flags"
		eerror  "enabled for vtk and then re-emerge vtk."
		die "vtk needs tk and python USE flags"
	fi
}

src_install() {
	distutils_src_install
	dodoc doc/{README,CREDITS,NEWS,TODO}.txt
	use doc && dohtml -r doc/guide/*
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi
}
