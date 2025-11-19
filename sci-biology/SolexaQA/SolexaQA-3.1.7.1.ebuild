# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Analyze and trim single-end and paired-end reads, show quality statistics"
HOMEPAGE="https://sourceforge.net/projects/solexaqa"
SRC_URI="https://sourceforge.net/projects/solexaqa/files/src/SolexaQA++_v${PV}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	virtual/zlib:=
	dev-libs/boost
"
BDEPEND="app-arch/unzip"
RDEPEND="${DEPEND}"

S="${WORKDIR}/source"

src_prepare() {
	default
	sed -i -e "s/\/lib/$(get_libdir)/g" -e "s/\/include/include\/boost/g" -e 's/-static//' makefile || die
}

src_install() {
	newbin SolexaQA++ "${PN}"
	einstalldocs
}
