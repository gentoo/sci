# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils git-r3

DESCRIPTION="Advanced Normalitazion Tools for neuroimaging"
HOMEPAGE="http://stnava.github.io/ANTs/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/stnava/ANTs.git"

SLOT="0"
LICENSE="BSD"
KEYWORDS=""

DEPEND="sci-libs/itk"
RDEPEND="${DEPEND}"

src_install() {
	cd "${WORKDIR}/${P}_build/ANTS-build" || die "build dir not found"
	emake DESTDIR="${D}" install
	cd "${WORKDIR}/${P}_build/Scripts" || die "scripts dir not found"
	dodir /usr/lib/ants
	install -t "${D}"usr/lib/ants *
}
