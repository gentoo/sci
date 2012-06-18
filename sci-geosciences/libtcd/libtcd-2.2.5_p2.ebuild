# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Upstream used -r# at the end of their files which would mess up gentoo's use
# of -r#.  Name ebuild _p# instead and replace as needed...
MY_P=${PN}-${PV/_p/-r}

DESCRIPTION="Library for reading and writing Tide Constituent Database (TCD) files."
HOMEPAGE="http://www.flaterco.com/xtide/libtcd.html"
SRC_URI="ftp://ftp.flaterco.com/xtide/${MY_P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND=">=sci-geosciences/harmonics-dwf-free-20120302"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${P%_*}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	if use doc ; then
		dohtml libtcd.html
	fi
}
