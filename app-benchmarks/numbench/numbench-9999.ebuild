# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils git-2

DESCRIPTION="Automated benchmarks suite"
HOMEPAGE=""
EGIT_REPO_URI="git://git.overlays.gentoo.org/proj/auto-numerical-bench.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND="!app-admin/eselect-blas
	 !app-admin/eselect-cblas
	 !app-admin/eselect-lapack
	 >=dev-python/matplotlib-1.0.0
	 =app-admin/eselect-1.2.16-r1"

src_install() {
	insinto /usr/$(get_libdir)/numbench
	doins *.py
	doins -r btl accuracy
	chmod +x "${D}"/usr/$(get_libdir)/numbench/main.py
	dosym /usr/$(get_libdir)/numbench/main.py /usr/bin/numbench
}
