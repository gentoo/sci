# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit fortran-2 toolchain-funcs versionator

MY_P="${P/-/}"

DESCRIPTION="Model-independent Parameter ESTimation for calibration and predictive uncertainty analysis"
HOMEPAGE="http://www.pesthomepage.org/"
SRC_URI="
	http://www.pesthomepage.org/getfiles.php?file=${MY_P}.tar.zip -> ${P}.tar.zip
	doc? (
		http://www.pesthomepage.org/files/pestman.pdf
		http://www.pesthomepage.org/files/addendum.pdf )"

# License is poorly specified on the SSPA web site.  It only says that
# Pest is freeware.
LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND=""

FORTRAN_STANDARD="90"

MAKEOPTS="${MAKEOPTS} -j1"

S="${WORKDIR}/${PN}"

src_unpack() {
	mkdir "${S}" && cd "${S}"
	unpack "${P}.tar.zip"
	unpack ./"${MY_P}.tar"
}

src_prepare() {
	# I decided it was cleaner to make all edits with sed, rather than a patch.
	sed -i \
		-e "s;^F90=.*;F90=$(tc-getFC);" \
		-e "s;^LD=.*;LD=$(tc-getFC);" \
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
	for mfile in pest.mak ppest.mak pestutl1.mak pestutl2.mak pestutl3.mak pestutl4.mak pestutl5.mak pestutl6.mak sensan.mak mpest.mak
		do
			emake -f ${mfile} all || die "${mfile} emake failed"
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
