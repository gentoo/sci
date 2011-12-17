# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils fortran-2 multilib toolchain-funcs

DESCRIPTION="Abinit AtomPAW atomic data convertor"
HOMEPAGE="http://www.abinit.org/downloads/PAW2/AtomPAW2Abinit-Manual-html/Old-AtomPAW2Abinit-Manual-html/AtomPAW2Abinit2.htm"
SRC_URI="http://www.abinit.org/downloads/PAW2/AtomPAW2Abinit-Manual-html/Old-AtomPAW2Abinit-Manual-html/Atompaw2Abinit.tgz -> ${P}.tgz"


LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	virtual/lapack
	virtual/blas
	sci-physics/atompaw"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/Atompaw2Abinit.v${PV}

pkg_nofetch() {
	elog "If there is a digest mismatch, please file a bug"
	elog "at https://bugs.gentoo.org/ -- a version bump"
	elog "is probably required."
}

src_configure() {
	head -n 6 Makefile >Makefile.1
	tail -n +6 Makefile >Makefile.2
	cp Makefile.1 Makefile
	echo FC = $(tc-getFC) >>Makefile
	echo FFLAGS = ${FCFLAGS:- ${FFLAGS:- -O2}} >>Makefile
	echo -n FFLAGS_LIBS= >>Makefile
	pkg-config --libs lapack >>Makefile
	echo >>Makefile
	sed -e's/^\(FC *=\)/#\1/' -e's/^\(FFLAGS *=\)/#\1/' \
		-e's/^\(FFLAGS_LIBS *=\)/#\1/' Makefile.2 >>Makefile
}

src_compile() {
	emake -j1 || die "Make failed"
}

src_install() {
	dobin atompaw2abinit
}
