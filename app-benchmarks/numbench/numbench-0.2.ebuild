# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Automated benchmarks suite"
HOMEPAGE="http://soc.dev.gentoo.org/~spiros"
SRC_URI="http://github.com/andyspiros/numbench/tarball/${PV} -> ${P}.tar.gz"
CID="127a61c"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND="
	!app-eselect/eselect-blas
	!app-eselect/eselect-cblas
	!app-eselect/eselect-lapack
	>=dev-python/matplotlib-1.0.0
	>=app-admin/eselect-1.3.2-r100"

python_install_all() {
	distutils-r1_python_install_all

	python_foreach_impl python_newscript exec.py numbench

	insinto /usr/share/numbench/samples
	doins samples/*.xml

	doman doc/numbench.1
}
