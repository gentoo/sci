# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
JAVA_PKG_OPT_USE="gui"

inherit java-pkg-opt-2 python-single-r1

DESCRIPTION="A Network Correctness and Performance Testing Language"
HOMEPAGE="http://conceptual.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD-2"
IUSE="gui"
KEYWORDS="~amd64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	virtual/mpi
	${PYTHON_DEPS}
	gui? (
		virtual/jdk:*
		dev-java/jython
	)"
DEPEND="${RDEPEND}"

src_compile() {
	default
	use gui && emake gui
}

src_install () {
	default
	if use gui; then
		java-pkg_newjar gui/ncptlGUI-1.5.1b.jar ${PN}.jar
		java-pkg_dolauncher
	fi
	python_optimize
}
