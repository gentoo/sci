# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

MY_P="${P/scikits_/scikits.}"

DESCRIPTION="SciPy module for manipulating, reporting, and plotting time series"
HOMEPAGE="http://pytseries.sourceforge.net/index.html"
SRC_URI="mirror://sourceforge/pytseries/${MY_P}.tar.gz
	doc? ( mirror://sourceforge/pytseries/${MY_P}-html_docs.zip )"

LICENSE="BSD eGenixPublic-1.0 eGenixPublic-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="dev-python/setuptools"
RDEPEND="sci-libs/scipy
	dev-python/matplotlib
	dev-python/pytables"

S="${WORKDIR}/${MY_P}"

src_install() {
	distutils_src_install
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r "${WORKDIR}/html" || die
	fi
}
