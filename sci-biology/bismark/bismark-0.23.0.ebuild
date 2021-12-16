# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Map bisulfite converted sequence reads and cytosine methylation states"
HOMEPAGE="https://www.bioinformatics.babraham.ac.uk/projects/"
SRC_URI="https://github.com/FelixKrueger/Bismark/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="sci-biology/bowtie"

S="${WORKDIR}/${P^}"

src_install() {
	dobin \
		bismark{,2bedGraph,2report,_genome_preparation,_methylation_extractor} \
		coverage2cytosine deduplicate_bismark
	einstalldocs
	dodoc -r Docs
}
