# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MYPN=galfit

inherit multilib

DESCRIPTION="Galaxy morphology fitting program"
HOMEPAGE="http://users.obs.carnegiescience.edu/peng/work/galfit/galfit.html"
CURI="http://users.obs.carnegiescience.edu/peng/work/${MYPN}"
SRC_URI="
	amd64? ( ${CURI}/${MYPN}3-debian64.tar.gz -> ${P}-amd64.tar.gz )
	x86? ( ${CURI}/${MYPN}3-debian32.tar.gz -> ${P}-x86.tar.gz )
	doc? ( ${CURI}/README.pdf -> ${MYPN}.pdf )
	examples? ( ${CURI}/${MYPN}-ex.tar.gz )
	test? ( ${CURI}/${MYPN}-ex.tar.gz )"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

RDEPEND="sys-libs/ncurses[tinfo]"
DEPEND=""

RESTRICT="mirror"

S="${WORKDIR}"

src_test() {
	chmod +x ${MYPN}
	cd ${MYPN}-example/EXAMPLE
	LD_LIBRARY_PATH=../.. ../../${MYPN} ${MYPN}.feedme
}

src_install () {
	dobin ${MYPN}
	use doc && newdoc "${DISTDIR}"/${MYPN}.pdf README.pdf
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins ${MYPN}-example/*
	fi
}
