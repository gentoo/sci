# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Probabilistic framework for structural variant discovery"
HOMEPAGE="https://github.com/arq5x/lumpy-sv"
SRC_URI="https://github.com/arq5x/lumpy-sv/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="sci-libs/htslib"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	# do not build bundled htslib, link to system lib
	sed -i -e 's/lumpy_filter: htslib/lumpy_filter:/g' Makefile || die
	sed -i -e 's/-I..\/..\/lib\/htslib\///' -e 's/..\/..\/lib\/htslib\/libhts.a/-lhts/g' src/filter/Makefile || die
}

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
	einstalldocs
}
