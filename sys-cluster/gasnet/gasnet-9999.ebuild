# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils

MY_P="${PN^^[gasn]}-${PV}"
DESCRIPTION="networking middleware layer to implementing partitioned global address space (PGAS) language"
HOMEPAGE="http://gasnet.lbl.gov/"

if [[ $PV = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://bitbucket.org/berkeleylab/${PN}.git"
	AUTOTOOLS_AUTORECONF=yes
else
	KEYWORDS="~amd64"
	SRC_URI="http://gasnet.lbl.gov/${MY_P}.tar.gz"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="BSD"
SLOT="0"
IUSE="mpi threads"

DEPEND="mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

pkg_setup() {
	echo
	elog "GASNet has an overwhelming count of configuration options."
	elog "Don't forget the EXTRA_ECONF environment variable can let you"
	elog "specify configure options if you find them necessary."
	echo
}

src_configure() {
	local myeconfargs=(
		$(use_enable threads pthreads)
		$(use_enable mpi)
	)
	autotools-utils_src_configure
}
