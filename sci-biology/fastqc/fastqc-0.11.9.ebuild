# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop java-pkg-2 xdg

DESCRIPTION="Quality control FASTA/FASTQ sequence files"
HOMEPAGE="https://www.bioinformatics.babraham.ac.uk/projects/fastqc/"
SRC_URI="https://github.com/s-andrews/FastQC/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/FastQC-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-lang/perl
	>=virtual/jre-1.8:*
"
DEPEND="
	dev-lang/perl
	>=virtual/jdk-1.8:*
"
BDEPEND="media-gfx/imagemagick"

src_prepare() {
	sed -i -E 's/<property name="source" value="[0-9.]+" \/>//g' build.xml || die
	sed -i -E 's/<property name="target" value="[0-9.]+" \/>//g' build.xml || die
	sed -i 's/source="${source}"//g' build.xml || die
	sed -i 's/target="${target}"//g' build.xml || die
	default
}

src_compile() {
	eant build \
		-Dant.build.javac.source="$(java-pkg_get-source)" \
		-Dant.build.javac.target="$(java-pkg_get-target)"
}

src_install(){
	insinto "opt/${PN}"
	doins -r bin/*
	chmod a+x "${ED}/opt/${PN}/fastqc"
	# add convenience symlink
	dosym ../${PN}/${PN} /opt/bin/${PN}

	convert ${PN}_icon.ico ${PN}.png || die
	doicon ${PN}.png
	make_desktop_entry ${PN} FastQC ${PN}
	einstalldocs
}
