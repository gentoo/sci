# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

MY_PV=${PV//./_}

DESCRIPTION="Multiple alignment of protein sequences with repeated and shuffled elements"
HOMEPAGE="http://proda.stanford.edu/"
SRC_URI="http://proda.stanford.edu/proda_${MY_PV}.tar.gz"

LICENSE="public-domain"
SLOT="0"
IUSE="debug"

KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"/${PN}

PATCHES=(
	"${FILESDIR}"/${P}-newgcc.patch
	"${FILESDIR}"/${P}-buildsystem.patch
	)

src_prepare() {
	default
	use debug || append-flags -DNDEBUG
	tc-export CXX
}

src_install() {
	dobin ${PN}
}
