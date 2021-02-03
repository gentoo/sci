# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils cmake

DESCRIPTION="Ultra fast and sensitive search and clustering suite"
HOMEPAGE="https://github.com/soedinglab/MMseqs2"
MY_PN="MMseqs2"

#The next two lines must be manually updated with each release
MY_PV="113e3"
FULL_PV="113e3212c137d026e297c7540e1fcd039f6812b1"

SRC_URI="https://github.com/soedinglab/${MY_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	app-shells/bash-completion
	sys-libs/zlib
	app-arch/bzip2
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}-${FULL_PV}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DVERSION_OVERRIDE=${PV}
	)
	cmake_src_configure
}

src_install(){
	cmake_src_install
	insinto /usr/share/bash-completion/completions/
	mv util/bash-completion.sh util/mmseqs
	doins util/mmseqs
	rm -r "$D"/usr/util/
}
