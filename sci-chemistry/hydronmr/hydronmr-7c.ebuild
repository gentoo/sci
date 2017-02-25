# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Calculation of NMR relaxation of small, quasirigid macromolecules"
HOMEPAGE="http://leonardo.inf.um.es/macromol/programs/hydronmr/hydronmr.htm"
SRC_URI="
	http://leonardo.inf.um.es/macromol/programs/hydronmr/hydronmr7c2lnx.exe
	http://leonardo.inf.um.es/macromol/programs/hydronmr/fast-hydronmr7c2lnx.exe
	http://leonardo.inf.um.es/macromol/programs/hydronmr/hydronmr.pdf
	http://leonardo.inf.um.es/macromol/programs/hydronmr/hydronmr7c.pdf
	http://leonardo.inf.um.es/macromol/programs/hydronmr/fast-hydronmr-1.pdf
	http://leonardo.inf.um.es/macromol/programs/hydronmr/fast-hydronmr-2.pdf
	examples? (
		http://leonardo.inf.um.es/macromol/programs/hydronmr/hydronmr.dat
		http://leonardo.inf.um.es/macromol/programs/hydronmr/6lyz.pdb
		http://leonardo.inf.um.es/macromol/programs/hydronmr/lysozyme31-nmr.res
		http://leonardo.inf.um.es/macromol/programs/hydronmr/lysozyme31-nmr.t12
		http://leonardo.inf.um.es/macromol/programs/hydronmr/lysozyme31-nmr-pri.bea
		http://leonardo.inf.um.es/macromol/programs/hydronmr/lysozyme31-fast-nmr.res
		http://leonardo.inf.um.es/macromol/programs/hydronmr/lysozyme31-fast-nmr.t12
	)"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

QA_PREBUILT="opt/bin/.*"

src_unpack() {
	mkdir -p "${S}" || die
	cd "${S}" || die
	cp "${DISTDIR}"/* . || die
}

src_install() {
	local exe
	for exe in *exe; do
		into /opt
		newbin ${exe} ${exe%7c2lnx.exe}
		rm ${exe} || die
	done
	dodoc *pdf
	rm -f *pdf || die

	if use examples; then
		insinto /usr/share/${PN}/examples
		doins *
	fi
}
