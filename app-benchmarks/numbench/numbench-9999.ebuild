# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils git-2 distutils

DESCRIPTION="Automated benchmarks suite"
HOMEPAGE="http://soc.dev.gentoo.org/~spiros"
EGIT_REPO_URI="git://git.overlays.gentoo.org/proj/auto-numerical-bench.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE=""

RDEPEND="!app-admin/eselect-blas
	 !app-admin/eselect-cblas
	 !app-admin/eselect-lapack
	 >=dev-python/matplotlib-1.0.0
	 =app-admin/eselect-1.3.1-r1
	 app-benchmarks/btl"

src_install() {
	distutils_src_install

	chmod +x exec.py
	newbin exec.py numbench

	insinto /usr/share/numbench/samples
	doins *.in

	doman doc/numbench.1
}
