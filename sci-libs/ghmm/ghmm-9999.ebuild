# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/mauvealigner/mauvealigner-9999.ebuild,v 1.1 2009/04/17 18:03:19 weaver Exp $

EAPI="2"

ESVN_REPO_URI="https://ghmm.svn.sourceforge.net/svnroot/ghmm/trunk/ghmm"

inherit subversion

DESCRIPTION="General Hidden Markov Model library - efficient data structures and algorithms for HMMs"
HOMEPAGE="http://ghmm.sourceforge.net/"
SRC_URI=""

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""
KEYWORDS=""

CDEPEND=""
DEPEND="${CDEPEND}"
RDEPEND="${CDEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	./autogen.sh
}

src_configure() {
	econf
	# fixme: hack
	sed -i 's|^prefix = \(.*\)|prefix = ${D}/usr|' {ghmmwrapper,HMMEd}/Makefile || die
}

src_install() {
	einstall || die
}
