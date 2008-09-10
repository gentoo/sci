# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils distutils

DESCRIPTION="Natural language processing tool collection"
HOMEPAGE="http://nltk.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://sourceforge/${PN}/${PN}-data-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="${DEPEND}
	dev-python/numarray
	dev-python/numpy
	dev-python/matplotlib
	>=app-dicts/wordnet-2.0
	sci-misc/pywordnet"
RDEPEND="${DEPEND}"

pkg_setup() {
	if ! built_with_use dev-lang/python tk ; then
		die "NLTK needs python built with USE=tk"
	fi
	export NLTK_DATA="${WORKDIR}/data/"
}

src_install() {
	distutils_src_install
	# N.B.: if you install corpora in usr/share/nltk you do not need env. vars
	cd "${WORKDIR}"
	dodir /usr/share/nltk
	fperms g+r data
	insinto /usr/share/nltk/
	doins -r data
}

