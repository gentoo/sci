# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="A diff program that ignores small numeric differences"
HOMEPAGE="http://www.math.utah.edu/~beebe/software/ndiff/"
SRC_URI="ftp://ftp.math.utah.edu/pub/misc/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="dev-libs/gmp:0="
RDEPEND="${DEPEND}"

# Rename the files from ndiff to numdiff, since /usr/bin/ndiff used to be
# provided by net-analyzer/nmap, before v4.85:
src_install() {
	newbin ndiff numdiff
	dodoc README* INSTALL ChangeLog
	newman ndiff.man numdiff.1
	if use doc ; then
		newdoc ndiff.html numdiff.html
		newdoc ndiff.pdf numdiff.pdf
		newdoc ndiff.ps numdiff.ps
		newdoc ndiff.txt numdiff.txt
	fi
	insinto /usr/share/${P}
	newins ndiff.awk numdiff.awk
}
