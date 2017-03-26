# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Structure determination program which builds on the X-PLOR program"
HOMEPAGE="http://nmr.cit.nih.gov/xplor-nih/"
SRC_URI="
	${P}-Linux_x86_64.tar.gz
	${P}-db.tar.gz
	"

SLOT="0"
LICENSE="XPLOR-NIH"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-lang/tcl:8.5
	dev-lang/tk:8.5
	dev-libs/libedit
	sys-libs/ncurses:5/5
"
DEPEND="${RDEPEND}"

RESTRICT="fetch"

QA_PREBUILT="opt/.*"

pkg_nofetch() {
	elog "Please visit ${HOMEPAGE} and download ${A}"
	elog "into ${DISTDIR}"
}

src_configure() { :; }

src_install() {
	dodoc Changes INSTALL README.beowulf README.dist References parallel.txt

	dodir /opt/${P} /opt/bin
	mv * "${ED}"/opt/${P}/ || die

	cd "${ED}"/opt/${P} || die
	bash ./configure -symlinks "${ED}"/opt/bin || die

	python_optimize /opt/${P}
}
