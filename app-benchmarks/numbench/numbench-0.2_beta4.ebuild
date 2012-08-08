# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils distutils

DESCRIPTION="Automated benchmarks suite"
HOMEPAGE="http://soc.dev.gentoo.org/~spiros"
SRC_URI="${HOMEPAGE}/repository/${P}.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND="!app-admin/eselect-blas
	 !app-admin/eselect-cblas
	 !app-admin/eselect-lapack
	 >=dev-python/matplotlib-1.0.0
	 =app-admin/eselect-1.3.1-r1"

src_install() {
	distutils_src_install

	chmod +x exec.py
	newbin exec.py numbench

	insinto /usr/share/numbench/samples
	doins samples/*.xml

	doman doc/numbench.1
}
