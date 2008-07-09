# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit fortran versionator

DESCRIPTION="Model-independent Parameter ESTimation for model calibration and
predictive uncertainty analysis."
HOMEPAGE="http://www.sspa.com/Pest"
SRC_URI="http://www.sspa.com/Pest/download/unixpest.zip
	doc? ( http://www.sspa.com/Pest/download/pestman.pdf )
	doc? ( http://www.sspa.com/Pest/download/addendum.pdf )"

# PEST uses '_' between versions
MY_PV=$(replace_all_version_separators '_')

# License is poorly specified on the SSPA web site.  It only says that
# Pest is freeware.
LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"
DEPEND="app-arch/unzip"
RDEPEND=""

MAKEOPTS="${MAKEOPTS} -j1"

# Need a Fortran 90 compiler.
FORTRAN="gfortran ifc"

S="${WORKDIR}/${PN}"

src_unpack() {
	mkdir "${S}" && cd "${S}"
	unpack unixpest.zip
	unpack ./"${PN}${MY_PV}.tar"

	# I decided it was cleaner to make all edits with sed, rather than a patch.
	sed -i \
		-e "s;^F90=.*;F90=${FORTRANC};" \
		-e "s;^LD=.*;LD=${FORTRANC};" \
		 *.mak makefile
	sed -i \
		-e "s;^FFLAGS=.*;FFLAGS=${FFLAGS:--O2} -c;" \
		 *.mak
	sed -i \
		-e "s;^INSTALLDIR=.*;INSTALLDIR=${D}/usr/bin;" \
		-e 's;^install :;install :\n\tinstall -d $(INSTALLDIR);' \
		 makefile
}


src_compile() {
	emake cppp || die "cppp emake failed"
	for mfile in pest.mak ppest.mak pestutl1.mak pestutl2.mak pestutl3.mak pestutl4.mak pestutl5.mak sensan.mak mpest.mak
		do
			emake -f ${mfile} all || die "${mfile} emake failed"
			emake clean || die "emake clean failed"
		done
}

src_install() {
	emake install || die "emake install failed"

	if use doc ; then
		dodoc "${DISTDIR}"/pestman.pdf
		dodoc "${DISTDIR}"/addendum.pdf
	fi

}

src_test() {
	ebegin "Running d_test"
	make d_test || die "make d_test failed"
	eend $?
}
