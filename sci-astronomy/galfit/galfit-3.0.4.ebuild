# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Galaxy morphology fitting program"
HOMEPAGE="http://www.csua.berkeley.edu/~cyp/work/galfit/galfit.html"
CURI="http://www.csua.berkeley.edu/~cyp/work/${PN}"
SRC_URI="amd64? ( ${CURI}/${PN}3-debian64.tar.gz )
	x86? ( ${CURI}/${PN}3-debian32.tar.gz )
	doc? ( ${CURI}/README.pdf -> galfit.pdf )
	examples? ( ${CURI}/galfit-ex.tar.gz )
	test? ( ${CURI}/${PN}/galfit-ex.tar.gz )"

RESTRICT="mirror"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"
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
