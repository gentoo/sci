# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Galaxy morphology fitting program"
HOMEPAGE="http://www.csua.berkeley.edu/~cyp/work/galfit/galfit.html"
SRC_URI="amd64? ( http://www.csua.berkeley.edu/~cyp/work/${PN}/${PN}3-debian64.tar.gz )
	x86? ( http://www.csua.berkeley.edu/~cyp/work/${PN}/${PN}3-debian.tar.gz )
	doc? ( http://www.csua.berkeley.edu/~cyp/work/${PN}/README.pdf -> galfit.pdf )
	examples? ( http://www.csua.berkeley.edu/~cyp/work/${PN}/galfit-ex.tar.gz )
	test? ( http://www.csua.berkeley.edu/~cyp/work/${PN}/galfit-ex.tar.gz )"

RESTRICT="mirror"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="doc examples"

RDEPEND="sys-libs/ncurses"
DEPEND=""

S="${WORKDIR}"

src_test() {
	cd galfit-example/EXAMPLE
	../../galfit galfit.feedme
}

src_install () {
	dobin galfit
	use doc && newdoc "${DISTDIR}"/galfit.pdf README.pdf
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins galfit-example/*
	fi
}
