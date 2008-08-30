# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit fortran versionator autotools

MV=$(get_major_version)
MY_PN=${PN}${MV}

DESCRIPTION="Lund Monte Carlo high-energy physics event generator"
HOMEPAGE="http://projects.hepforge.org/pythia6/"

# pythia6 from root is needed for some files to interface pythia6 with root
SRC_URI="http://www.hepforge.org/archive/${MY_PN}/${P}.f.gz
	ftp://root.cern.ch/root/pythia6.tar.gz
	http://www.hepforge.org/archive/${MY_PN}/update_notes-${PV}.txt
	doc? ( http://home.thep.lu.se/~torbjorn/pythia/lutp0613man2.pdf
		   http://home.thep.lu.se/~torbjorn/pythia/main60.f )"

LICENSE="public-domain"
SLOT="6"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
DEPEND=""

S="${WORKDIR}"

FORTRAN="gfortran ifc g77"

src_unpack() {
	unpack ${A}
	cat > configure.ac <<-EOF
		AC_INIT(${PN},${PV})
		AM_INIT_AUTOMAKE
		AC_PROG_F77
		AC_PROG_LIBTOOL
		AC_CONFIG_FILES(Makefile)
		AC_OUTPUT
	EOF
	cat > Makefile.am <<-EOF
		lib_LTLIBRARIES = lib${MY_PN}.la
		lib${MY_PN}_la_SOURCES = ${P}.f \
			= pythia6/tpythia6_called_from_cc.F \
			= pythia6/pythia6_common_address.c
	EOF
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc "${DISTDIR}"/update_notes-${PV}.txt
	if use doc; then
		insinto /usr/share/doc/${PF}/
		doins "${DISTDIR}"/{lutp0613man2.pdf,main60.f} || die
	fi
}

pkg_postinst() {
	elog "pythia-6 ebuild is still under development."
	elog "Help us improve the ebuild in:"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=231484"
}
