# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit fortran toolchain-funcs versionator

MY_PV="$(get_version_component_range 1-2 ${PV})"
MY_PV="$(replace_all_version_separators _ ${MY_PV})"
DESCRIPTION="Checks the stereochemical quality of a protein structure"
HOMEPAGE="http://www.biochem.ucl.ac.uk/~roman/procheck/procheck.html"
SRC_URI="ftp://ftp.biochem.ucl.ac.uk/pub/${PN}/tar${MY_PV}/procheck.tar.Z
	ftp://ftp.biochem.ucl.ac.uk/pub/${PN}/tar${MY_PV}/manual.tar.Z"
LICENSE="procheck"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="app-shells/tcsh"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}"

FORTRAN="gfortran g77"

src_compile() {
	emake \
		F77=${FORTRANC} \
		CC=$(tc-getCC) \
		COPTS="${CFLAGS}" \
		FOPTS="${FFLAGS}" \
		|| die "emake failed"
}

src_install() {
	for i in *.scr; do
		newbin ${i} ${i%.scr} || die
	done

	exeinto /usr/$(get_libdir)/${PN}/
	doexe \
		anglen \
		bplot \
		clean \
		gfac2pdb \
		mplot \
		nb \
		pplot \
		rmsdev \
		secstr \
		tplot \
		viol2pdb \
		vplot \
		wirplot || die
	dodoc README

	insinto /usr/$(get_libdir)/${PN}/
	doins procheck.dat procheck.prm procheck_comp.prm procheck_nmr.prm || die
	newins resdefs.dat resdefs.data || die

	cat <<- EOF >> "${T}"/30${PN}
	prodir="${ROOT}usr/$(get_libdir)/${PN}/"
	EOF


	insinto /etx/profile.d/
	doins "${T}"/30${PN}

	pushd "${WORKDIR}"
	dohtml -A prm,txt -r manual/*
	popd
}
