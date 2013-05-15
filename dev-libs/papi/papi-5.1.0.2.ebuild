# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit versionator

DESCRIPTION="Performance Application Programming Interface"
HOMEPAGE="http://icl.cs.utk.edu/papi/index.html"
SRC_URI="http://icl.cs.utk.edu/projects/papi/downloads/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="
	dev-libs/libpfm[static-libs]
	"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-$(get_version_component_range 1-3)/src"

src_configure() {
	econf \
		--with-perf-events \
		--with-pfm-prefix="${EPREFIX}/usr" \
		$(use_with static-libs)
}
