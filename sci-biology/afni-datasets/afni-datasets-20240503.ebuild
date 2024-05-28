# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="afni_atlases_dist_2024_0503"

DESCRIPTION="Datasets for using and testing sci-biology/afni"
HOMEPAGE="https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/"
SRC_URI="https://afni.nimh.nih.gov/pub/dist/atlases/${MY_P}.tgz -> ${P}.tar.gz"

S="${WORKDIR}/${MY_P}"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_install() {
	insinto /usr/share/${PN}
	doins -r *
}
