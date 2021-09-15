# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A tool to estimate, store, and access very large n-gram language models"
HOMEPAGE="https://hlt-mt.fbk.eu/technologies/irstlm"
SRC_URI="https://github.com/irstlm-team/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc static-libs"

BDEPEND="doc? ( app-text/texlive[extra] )"

PATCHES=(
	"${FILESDIR}"/${P}-remove-lib-linking.patch
	"${FILESDIR}"/${P}-doc-obey-docdir.patch
)

src_prepare() {
	default
	# Remove AM_CXXFLAGS that are breaking the package or should not be there
	# Bug: https://bugs.gentoo.org/755473
	sed -e 's/-static -isystem\/usr\/include -W //' -i src/Makefile.am
	# Needed for doc
	cp "${S}/doc/RELEASE" "${S}/RELEASE.tex"
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable doc)
}
