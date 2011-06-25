# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils git-2

DESCRIPTION="Manual for gromacs"
HOMEPAGE="http://www.gromacs.org/"
SRC_URI=""

EGIT_REPO_URI="git://git.gromacs.org/manual"
EGIT_BRANCH="master"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	~sci-chemistry/gromacs-${PV}
	dev-texlive/texlive-latex
	sys-apps/coreutils
	app-shells/tcsh"
RDEPEND=""

src_prepare() {
	local progs
	progs=$(tr '\n' ' ' <${EROOT}usr/share/gromacs/programs.list) || die
	sed -i "s/^\(PROGRAMS\).*/\1='${progs}'/" mkman || die
	sed -i "s@^\(INSTALLED.*=\).*@\1${EROOT}usr/bin/g_options@" mkoptions || die
	sed \
		-e "s!\${GMXSRC}/admin/\(programs.txt\)!${EROOT}usr/share/gromacs/\1!" \
		-e "s!\${GMXSRC}/share/html!${EROOT}usr/share/doc/gromacs-${PV}/html!" \
		-e "s!\${GMXBIN}!${EROOT}usr/bin!" \
		-e '/FATAL_ERROR.*GMX\(SRC\|BIN\)/s/^/#/' \
		-i CMakeLists.txt || die "sed of CMakeLists.txt failed"
}

src_install() {
	insinto /usr/share/doc/gromacs-${PV}
	newins ${CMAKE_BUILD_DIR}/gromacs.pdf manual-${PV}.pdf
}
