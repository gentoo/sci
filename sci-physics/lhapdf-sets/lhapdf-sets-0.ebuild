# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
LHA_VER="6.2.1"

IUSE_LHAPDF_SETS="
	lhapdf_sets_nnpdf31_nnlo_as_0118_luxqed
	lhapdf_sets_pdf4lhc15_nlo_asvar
	lhapdf_sets_pdf4lhc15_nnlo_100
	lhapdf_sets_ct14qed_proton
	lhapdf_sets_ct14lo
	lhapdf_sets_ct14nlo
	lhapdf_sets_ct10
	lhapdf_sets_ct10nnlo
	lhapdf_sets_mrst2007lomod
	lhapdf_sets_nnpdf23_nlo_as_0119_qed_mc
	lhapdf_sets_nnpdf23_nnlo_as_0119_qed_mc
	lhapdf_sets_cteq66
	lhapdf_sets_cteq6l1
	lhapdf_sets_mrst2004qed
	lhapdf_sets_nnpdf23_nlo_as_0118
	lhapdf_sets_nnpdf31_nnlo_as_0118
"

DESCRIPTION="LHAPDF data grids"
HOMEPAGE="https://lhapdf.hepforge.org/"
COMMON_URI="https://lhapdfsets.web.cern.ch/lhapdfsets/current"
HEPFORGE_URI="https://www.hepforge.org/downloads/lhapdf/pdfsets/v6.backup/${LHA_VER}"
# Alternatively to fetching them here already the user can install them by lhapdf install,
# BUT some codes need them during test and even compile (Herwig) stage.
# Also since it belongs to LHAPDF it is better to fetch them here.
SRC_URI="
	lhapdf_sets_nnpdf31_nnlo_as_0118_luxqed? ( ${COMMON_URI}/NNPDF31_nnlo_as_0118_luxqed.tar.gz )
	lhapdf_sets_pdf4lhc15_nlo_asvar?         ( ${COMMON_URI}/PDF4LHC15_nlo_asvar.tar.gz         )
	lhapdf_sets_pdf4lhc15_nnlo_100?          ( ${COMMON_URI}/PDF4LHC15_nnlo_100.tar.gz          )
	lhapdf_sets_ct14qed_proton?              ( ${COMMON_URI}/CT14qed_proton.tar.gz              )
	lhapdf_sets_ct14lo?                      ( ${COMMON_URI}/CT14lo.tar.gz                      )
	lhapdf_sets_ct14nlo?                     ( ${COMMON_URI}/CT14nlo.tar.gz                     )
	lhapdf_sets_ct10?                        ( ${COMMON_URI}/CT10.tar.gz                        )
	lhapdf_sets_ct10nnlo?                    ( ${COMMON_URI}/CT10nnlo.tar.gz                    )
	lhapdf_sets_mrst2007lomod?               ( ${COMMON_URI}/MRST2007lomod.tar.gz               )
	lhapdf_sets_nnpdf23_nlo_as_0119_qed_mc?  ( ${COMMON_URI}/NNPDF23_nlo_as_0119_qed_mc.tar.gz  )
	lhapdf_sets_nnpdf23_nnlo_as_0119_qed_mc? ( ${COMMON_URI}/NNPDF23_nnlo_as_0119_qed_mc.tar.gz )
	lhapdf_sets_cteq66?                      ( ${COMMON_URI}/cteq66.tar.gz                      )
	lhapdf_sets_cteq6l1?                     ( ${COMMON_URI}/cteq6l1.tar.gz                     )
	lhapdf_sets_mrst2004qed?                 ( ${HEPFORGE_URI}/MRST2004qed.tar.gz               )
	lhapdf_sets_nnpdf23_nlo_as_0118?         ( ${COMMON_URI}/NNPDF23_nlo_as_0118.tar.gz         )
	lhapdf_sets_nnpdf31_nnlo_as_0118?        ( ${COMMON_URI}/NNPDF31_nnlo_as_0118.tar.gz        )
"

MY_PV=$(ver_cut 1-3)
MY_PF=LHAPDF-${MY_PV}

S="${WORKDIR}"
LICENSE="public-domain"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="${IUSE_LHAPDF_SETS}"
RDEPEND="sci-physics/lhapdf"
DEPEND="${RDEPEND}"

src_unpack() {
	# unpack in destination only to avoid copy
	return
}

src_install() {
	dodir /usr/share/LHAPDF/
	cd "${ED}/usr/share/LHAPDF/" || die
	unpack ${A}
}
