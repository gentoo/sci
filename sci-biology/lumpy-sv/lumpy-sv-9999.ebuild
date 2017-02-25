# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Probabilistic framework for structural variant discovery"
HOMEPAGE="https://github.com/arq5x/lumpy-sv"
EGIT_REPO_URI="https://github.com/arq5x/lumpy-sv.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

# contains bundled htslib
CDEPEND="dev-util/cmake"
DEPEND=""
RDEPEND="${DEPEND}"

src_install(){
	cat > "${T}"/99lumpy-sv <<- EOF
	LUMPY_HOME=${EPREFIX}/usr/share/lumpy-sv
	PAIREND_DISTRO=${EPREFIX}/usr/share/lumpy-sv/scripts/pairend_distro.py
	BAMGROUPREADS=${EPREFIX}/usr/share/lumpy-sv/scripts/bamkit/bamgroupreads.py
	BAMFILTERRG=${EPREFIX}/usr/share/lumpy-sv/scripts/bamkit/bamfilterrg.py
	BAMLIBS=${EPREFIX}/usr/share/lumpy-sv/scripts/bamkit/bamlibs.py
	EOF
	doenvd "${T}"/99lumpy-sv
	rm -f bin/lumpyexpress.config
	dobin bin/*
	insinto /usr/share/lumpy-sv/scripts
	for f in lumpyexpress lumpyexpress.config; do
		rm scripts/"$f" || die
	done
	doins scripts/*
	dodoc README.md
	insinto /usr/share/lumpy-sv/scripts/bamkit
	cd scripts/bamkit || die
	doins *.py sectosupp
	newdoc README.md README_bamkit.md
}
