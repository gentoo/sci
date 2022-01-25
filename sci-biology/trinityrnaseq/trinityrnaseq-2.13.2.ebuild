# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module

DESCRIPTION="Transcriptome assembler for RNA-seq reads"
HOMEPAGE="https://github.com/Trinotate/Trinotate.github.io/wiki"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/Trinity-v${PV}/${PN}-v${PV}.FULL_with_extendedTestData.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="BSD-BroadInstitute"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}
	sci-biology/parafly
	>=sci-biology/jellyfish-2.2.6:2
	>=sci-libs/htslib-1.2.1
	>=sci-biology/samtools-1.3:0
	>=sci-biology/trimmomatic-0.36
	>=sci-biology/GAL-0.2.1
	dev-perl/IO-All
	sci-biology/seqtools
"

PATCHES=(
	"${FILESDIR}/${PN}-2.11.0-fix-compilation.patch"
)

src_compile(){
	# missing submodule for bamsifter
	emake no_bamsifter
	emake plugins
}

src_install(){
	# fix the install path
	sed -e "s:/usr/local/bin:${ED}/usr/bin:g" \
		-i util/support_scripts/trinity_installer.py || die
	dodir /usr/bin
	default
}
