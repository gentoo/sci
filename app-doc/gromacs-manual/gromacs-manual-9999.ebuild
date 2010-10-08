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
	./mkmdp /usr/share/doc/gromacs-${PV}/html || die "mkmdp failed"
	progs=$(sed -e '/luck/d' /usr/share/gromacs/programs.list | tr '\n' ' ') || \
		die "sed of programs.list failed"
	echo "Building manpages for ${progs}"
	sed -e "s@^set PROGRAMS.*@set PROGRAMS = '${progs}'@" mkman > mkman.gentoo || \
		die "sed of mkman failed"
	cmp -s mkman mkman.gentoo && die "sed of mkman.gentoo failed"
	chmod 755 ./mkman.gentoo || die "chmod of mkman.gentoo failed"
	./mkman.gentoo /usr/bin || die "mkman failed"
	cp /usr/share/gromacs/programs.txt . || die "cp of programs.txt failed"
	./mk_proglist || die "mk_proglist failed"
	g_options  -man tex || die "g_options failed"
	mv g_options.tex options.tex || die "mv of options.tex failed"
	make pdf
}

src_install() {
	insinto /usr/share/doc/gromacs-${PV}
	newins gromacs.pdf manual-${PV}.pdf
}
