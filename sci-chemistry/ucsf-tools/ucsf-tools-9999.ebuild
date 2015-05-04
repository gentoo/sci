# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_AUTORECONF=y

inherit autotools-utils flag-o-matic

DESCRIPTION="The USF program suite"
HOMEPAGE="http://xray.bmc.uu.se/usf/"
SRC_URI="
	http://xray.bmc.uu.se/markh/usf/usf_distribution_kit.tar.gz -> ${P}.tar.gz
	http://dev.gentoo.org/~jlec/distfiles/mark-20110912.tgz"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
"

S="${WORKDIR}"/usf_export

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}"
	unpack mark-20110912.tgz
}

src_prepare() {
	local src
	append-fflags -ffixed-line-length-132
	for src in \
		ave coma comap comdem dataman essens imp lsqman mama mapfix \
		mapman mave ncs6d o2d prof solex spancsi; do
			mv ${src}/${src}.{f,F} || die
	done
	autotools-utils_src_prepare
}
