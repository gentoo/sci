# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# inherit

DESCRIPTION="Program that predicts protein flexibility by calculating the"
HOMEPAGE="Random Coil Index from backbone chemical shiftshttp://redpoll.pharmacy.ualberta.ca/download/rci/"
SRC_URI="http://dev.gentooexperimental.org/~jlec/science-dist/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-visualization/gnuplot"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/RCI

src_test() {
	python  rci_v_1c.py -b PyJCScorr
	diff PyJCScorr_RCI.txt_compare PyJCScorr.RCI.txt >& /dev/null || \
		die "test failed"
}

src_install() {
	newbin rci_v_1c.py ${PN} || die
	dodoc README
}
