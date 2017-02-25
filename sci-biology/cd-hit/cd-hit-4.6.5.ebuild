# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic toolchain-funcs

RELDATE="2016-03-04"
RELEASE="${PN}-v${PV}-${RELDATE}"

DESCRIPTION="Clustering Database at High Identity with Tolerance"
HOMEPAGE="http://weizhong-lab.ucsd.edu/cd-hit
	http://weizhongli-lab.org/cd-hit"
SRC_URI="https://github.com/weizhongli/cdhit/archive/V${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-2"
IUSE="doc openmp"

DEPEND="!sci-biology/cd-hit-auxtools"

S="${WORKDIR}"/cdhit-"${PV}"

pkg_setup() {
	 use openmp && ! tc-has-openmp && die "Please switch to an openmp compatible compiler"
}

src_prepare() {
	tc-export CXX
	use openmp || append-flags -DNO_OPENMP
	epatch "${FILESDIR}"/${PV}-gentoo.patch
}

src_compile() {
	local myconf=
	use openmp && myconf="openmp=yes"
	emake ${myconf}
	cd cd-hit-auxtools || die
	emake ${myconf}
}

src_install() {
	dodir /usr/bin
	emake PREFIX="${ED}/usr/bin" install
	dobin psi-cd-hit/*.pl cd-hit-auxtools/*.pl cd-hit-auxtools/{cd-hit-lap,read-linker,cd-hit-dup}
	dodoc ChangeLog psi-cd-hit/README.psi-cd-hit
	use doc && dodoc doc/* psi-cd-hit/qsub-template "${FILESDIR}"/cd-hit-auxtools-manual.txt
}

pkg_postinst(){
	einfo "From the original http://weizhong-lab.ucsd.edu/software/cdhit-454 package"
	einfo "we still lack cdhit-cluster-consensus part. You may want to install yourself"
	einfo "http://weizhong-lab.ucsd.edu/softwares/cd-hit-454/cdhit-cluster-consensus-2013-03-27.tgz"
	einfo ""
	einfo "The cd-hit-auxtools are no longer a separate package and belong to cd-hit since"
	einfo "version 4.6.5. However, there is no manual for that in current cd-hit tree. Therefore"
	einfo "see http://weizhong-lab.ucsd.edu/cd-hit/wiki/doku.php?id=cd-hit-auxtools-manual"
	einfo "A local copy is is in /usr/share/doc/${PN}/cd-hit-auxtools-manual.txt"
}
