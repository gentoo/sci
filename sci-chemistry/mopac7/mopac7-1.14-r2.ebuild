# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/mopac7/mopac7-1.14-r1.ebuild,v 1.2 2009/01/19 00:27:40 mr_bones_ Exp $

inherit autotools fortran

DESCRIPTION="Autotooled, updated version of a powerful, fast semi-empirical package"
HOMEPAGE="http://sourceforge.net/projects/mopac7/"
SRC_URI="http://www.bioinformatics.org/ghemical/download/current/${P}.tar.gz
		http://wwwuser.gwdg.de/~ggroenh/qmmm/mopac/gmxmop.f"

LICENSE="mopac7"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="gmxmopac7"
RDEPEND=""
DEPEND="${RDEPEND}"

FORTRAN="gfortran"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Install the executable
	sed -i \
		-e "s:noinst_PROGRAMS = mopac7:bin_PROGRAMS = mopac7:g" \
		fortran/Makefile.am \
		|| die "sed failed: install mopac7"
	# Install the script to run the executable
	sed -i \
		-e "s:EXTRA_DIST = autogen.sh run_mopac7:bin_SCRIPTS = run_mopac7:g" \
		Makefile.am \
		|| die "sed failed: install run_mopac7"

	# Fix parallel build by adding internal dependency on libmopac7.la from
	# executable
	sed -i \
		-e "s:mopac7_LDFLAGS = -lmopac7 -lm:mopac7_LDFLAGS = -lm:g" \
		-e "s:\(mopac7_LDFLAGS.*\):\1\nmopac7_LDADD = libmopac7.la:g" \
		fortran/Makefile.am \
		|| die "sed failed: fix dependencies"

	eautoreconf
}

src_compile() {
	#set -std=legacy -fno-automatic according to
	#http://www.bioinformatics.org/pipermail/ghemical-devel/2008-August/000763.html
	FFLAGS="${FFLAGS} -std=legacy -fno-automatic" econf
	emake || die "mopac7 failed to build."
}

src_install() {
	# A correct fix would have a run_mopac7.in with @bindir@ that gets
	# replaced by configure, and run_mopac7 added to AC_OUTPUT in configure.ac
	sed -i "s:./fortran/mopac7:mopac7:g" run_mopac7

	make DESTDIR="${D}" install || die
	dodoc AUTHORS README ChangeLog
	if use gmxmopac7; then
		einfo "Making static mopac7 lib for gromacs"
		cp "${DISTDIR}"/gmxmop.f "${S}"/fortran
		cd "${S}"/fortran
		rm -f *.o
		rm -f moldat.f deriv.f mopac7*.f
		$(tc-getFC) ${FFLAGS} -fPIC -std=legacy -fno-automatic -c *.f
		ar rcv libgmxmopac7.a *.o
		ranlib libgmxmopac7.a
		dolib.a ${S}/fortran/libgmxmopac7.a
	fi
}
