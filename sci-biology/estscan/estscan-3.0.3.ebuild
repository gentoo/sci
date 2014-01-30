# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils fortran-2 perl-module toolchain-funcs

DESCRIPTION="Prediction of coding regions in DNA/RNA sequences"
HOMEPAGE="http://sourceforge.net/projects/estscan/"
SRC_URI="
	http://downloads.sourceforge.net/estscan/estscan-3.0.3.tar.gz
	http://downloads.sourceforge.net/estscan/At.smat.gz
	http://downloads.sourceforge.net/estscan/Dm.smat.gz
	http://downloads.sourceforge.net/estscan/Dr.smat.gz
	http://downloads.sourceforge.net/estscan/Hs.smat.gz
	http://downloads.sourceforge.net/estscan/Mm.smat.gz
	http://downloads.sourceforge.net/estscan/Rn.smat.gz
	http://downloads.sourceforge.net/estscan/user_guide_fev_07.pdf
	http://downloads.sourceforge.net/estscan/BTLib-0.19.tar.gz"

SLOT="0"
LICENSE="estscan"
KEYWORDS="~x86 ~amd64"
IUSE="icc ifc"

DEPEND="
	virtual/fortran
	icc? ( dev-lang/icc )
	ifc? ( dev-lang/ifc )
	dev-perl/BTLib"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_prepare() {
	sed \
		-e 's/\\rm -f/rm -rf/' \
		-e 's/^ LDFLAGS = -lm/LDFLAGS = -lm/' \
		-i "${P}"/Makefile || die "failed to edit Makefile"

	# fix hard-coded paths
	sed -e 's+/usr/molbio/share/ESTScan+/usr/share/ESTscan+' -i "${P}"/estscan.c || die
	sed -e 's+/usr/molbio/share/ESTScan+/usr/share/ESTscan+' -i "${P}"/estscan.spec || die

	if ! use icc; then
		sed \
			-e 's/^ CFLAGS = -O2/#CFLAGS = ${CFLAGS}/' -i "${P}"/Makefile || die
	fi

	if ! use ifc; then
		sed \
			-e 's/^ FFLAGS = -O2/#FFLAGS = ${FFLAGS}/' \
			-e "s/^ F77 = g77/F77 = $(tc-getF77)/" -i "${P}"/Makefile \
			|| die
	fi

	if use icc; then
		# FIXME: I would use $(tc-getCC) instead of hard-coded icc but it gives
		# me gcc instead, same for $(tc-getF77)
		# Moreover, the if/else logic here should separate users having only icc
		# while not ifort (and vice-versa) from those having only
		# gcc/gfortran/g77
		#
		# FIXME: below as a dirty hack I force gfortran instead of ifort for
		# my testing purposes. Didn't ebuild contain "PROVIDES" line?
		# Same for FFLAGS.
		sed \
			-e "s:^# CC = icc:CC = icc:" \
			-e "s:^# CFLAGS = -O3 -ipo -axP:#CFLAGS = -O3 -ipo -axP:" \
			-e "s/^ CFLAGS = -O2/#CFLAGS = -O2/" \
			-e "s/^ CC = gcc/# CC = gcc/" \
			-i "${P}"/Makefile || die "sed failed to fix CFLAGS and CC"

	fi

	if use ifc; then
		sed \
			-e "s:^# FFLAGS = -O3 -ipo -axP:#FFLAGS = -O3 -ipo -axP:" \
			-e "s/^# F77 = ifort/F77 = gfortran/" \
			-e "s/^ FFLAGS = -O2/#FFLAGS = -O2/" \
			-e "s/^ F77 = g77/# F77 = g77/" \
			-i "${P}"/Makefile || die "sed failed to fix FFLAGS and F77"
	fi
}

src_compile() {
	emake -C ${P}
}

src_install() {
	# FIXME: Some kind of documentation is in {P}/estscan.spec
	cd ${P} || die "Failed to chdir to ${P}"
	dobin \
		build_model estscan evaluate_model extract_EST extract_UG_EST \
		extract_mRNA makesmat maskred prepare_data winsegshuffle
	# the file build_model_utils.pl should go into some PERL site-packages dir
	# see {P}/estscan.spec

	# install the doc (but is not in ${WORKDIR} because src_unpack() failed on it as it has .pdf extension
	cd "${DISTDIR}" || die "Failed to chdir to ${DISTDIR}"
	insinto /usr/share/doc/ESTscan
	# grab the file directly from ../distdir/
	doins "${DISTDIR}"/user_guide_fev_07.pdf

	# install the default precomputed matrices
	cd "${WORKDIR}" || die "Failed to chdir to ${WORKDIR}"
	insinto /usr/share/ESTscan
	doins *.smat

	# install BTlib (in perl)
	# dobin fetch indexer netfetch
	insinto /usr/share/ESTscan/
	# install the config file which is packed inside the BTLib tarball while is not
	# being installed by dev-perl/BTLib
	doins "${WORKDIR}"/BTLib-0.19/fetch.conf

	# FIXME: install the *.pm files from BTLib-0.19
	# cd "${WORKDIR}"/BTLib-0.19 || die "Failed to chdir to "${WORKDIR}"/BTLib-0.19
	# myinst="DESTDIR=${D}"
	# perl-module_src_install

	einfo "Please edit /usr/share/ESTscan/fetch.conf to fit your local database layout."
	einfo "Also create your own scoring matrices and place them into /usr/share/ESTscan/."
	einfo "You may follow the hints from http://estscan.sourceforge.net/"
}
