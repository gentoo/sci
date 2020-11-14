# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 eutils java-ant-2 prefix

DESCRIPTION="Quality control FASTA/FASTQ sequence files"
HOMEPAGE="https://www.bioinformatics.babraham.ac.uk/projects/fastqc/"
SRC_URI="https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v"${PV}"_source.zip"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND} >=virtual/jdk-1.5:*"
BDEPEND="app-arch/unzip"

S="${WORKDIR}"/FastQC

src_prepare(){
	cp "${FILESDIR}"/build.xml . || die
	default
}

src_compile(){
	ant || die
}

src_install(){
	insinto "opt/${PN}"
	doins -r bin
	chmod a+x "${ED}/opt/${PN}/bin/fastqc"
	# Add the package's bin directory to the PATH.
	doenvd "${FILESDIR}/00fastqc"
	if use prefix ; then
		hprefixify "${ED}/etc/env.d/00fastqc"
	fi

	dodoc README.txt RELEASE_NOTES.txt
}

pkg_postinst() {
	ewarn "Remember to run: env-update && source \"${EPREFIX}/etc/profile\" if you plan"
	ewarn "to use this tool in a shell before logging out (or restarting"
	ewarn "your login manager)"
}
