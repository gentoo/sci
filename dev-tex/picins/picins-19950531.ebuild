# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit latex-package

DESCRIPTION="Insert pictures into paragraphs"
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex209/contrib/picins/"
SRC_URI="http://www.ctan.org/get/macros/latex209/contrib/picins.zip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

S="${WORKDIR}/${PN}"

src_install() {
	latex-package_src_install
	dodoc README.1st
}
