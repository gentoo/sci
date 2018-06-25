# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils multilib

DESCRIPTION="Advanced Normalitazion Tools for neuroimaging"
HOMEPAGE="http://stnava.github.io/ANTs/"
SRC_URI="https://github.com/ANTsX/ANTs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-util/cmake-3.10.3"
RDEPEND=""

S="${WORKDIR}/ANTs-${PV}"

src_install() {
	cd "${WORKDIR}/${P}_build/ANTS-build" || die "build dir not found"
	default
	cd "${S}/Scripts" || die "scripts dir not found"
	dobin *.sh
	dodir /usr/$(get_libdir)/ants
	install -t "${D}"usr/$(get_libdir)/ants *
	doenvd "${FILESDIR}"/99ants
}
