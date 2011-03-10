# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

EGIT_REPO_URI="git://git.gromacs.org/manual"
EGIT_BRANCH="master"

inherit git

DESCRIPTION="Manual for gromacs"
HOMEPAGE="http://www.gromacs.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="=sci-chemistry/gromacs-${PV}
	dev-texlive/texlive-latex
	sys-apps/coreutils
	app-shells/tcsh"

RDEPEND=""

src_compile() {
	local progs
	einfo "Building mdp option file"
	./mkmdp /usr/share/doc/gromacs-${PV}/html || die
	progs=$(sed -e '/g_luck/d' /usr/share/gromacs/programs.list | tr '\n' ' ') || \
		die "sed of programs.list failed"
	einfo "Building manpages for ${progs}"
	sed -i "s@^\(set PROGRAMS\).*@\1 = '${progs}'@" mkman || die
	./mkman /usr/bin || die
	cp /usr/share/gromacs/programs.txt . || die
	einfo "Building program list"
	./mk_proglist || die
	einfo "Building common option file"
	emake g_options.tex || die
	einfo "Building pdf manual"
	emake pdf || die
}

src_install() {
	insinto /usr/share/doc/gromacs-${PV}
	newins gromacs.pdf manual-${PV}.pdf
}
