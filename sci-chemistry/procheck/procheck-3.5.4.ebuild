# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils fortran toolchain-funcs versionator

DESCRIPTION="Checks the stereochemical quality of a protein structure"
HOMEPAGE="http://www.biochem.ucl.ac.uk/~roman/procheck/procheck.html"
SRC_URI="
	http://www.ebi.ac.uk/systems-srv/mp/file-exchange/${PN}.tar.gz?fno=2874 -> ${P}.tar.gz
	http://www.ebi.ac.uk/systems-srv/mp/file-exchange/manual.tar.gz?fno=2568 -> ${P}-manual.tar.gz"

LICENSE="procheck"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="app-shells/tcsh"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

FORTRAN="gfortran g77"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-ldflags.patch
}

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
	prodir="${EPREFIX}/usr/$(get_libdir)/${PN}/"
	EOF


	insinto /etx/profile.d/
	doins "${T}"/30${PN} || die

	if use doc; then
		pushd "${WORKDIR}"
			dohtml -A prm,txt -r manual/* || die
		popd
	fi
}
