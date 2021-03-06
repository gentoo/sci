# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Verify sample identity/mix and genotype concordance"
HOMEPAGE="http://genome.sph.umich.edu/wiki/VerifyBamID"
SRC_URI="https://github.com/statgen/verifyBamID/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/statgen/libStatGen/archive/v1.0.15.tar.gz -> libStatGen-1.0.15.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# DEPEND="sci-libs/libStatGen" # TODO: currently it uses its own bundled copy
DEPEND=""
RDEPEND="${DEPEND}"

src_prepare(){
	# unpack ./libStatGen-1.0.13/ contents
	gzip -dc "${DISTDIR}"/libStatGen-1.0.15.tar.gz | tar xf - || die
	ln -s libStatGen-1.0.15 libStatGen || die
	cd "${WORKDIR}" || die
	ln -s libStatGen-1.0.15 libStatGen || die
	sed -e 's/-Werror//' -i verifyBamID-1.1.3/src/Makefile || die
	sed -e 's/-Werror//' -i verifyBamID-1.1.3/libStatGen-1.0.15/general/Makefile || die
	default
}

src_compile(){
	# LIB_PATH_GENERAL="${EPREFIX}"/usr/"$(get_libdir)" emake
	LIB_PATH_GENERAL="../libStatGen-1.0.15" emake USER_WARNINGS=' '
}

src_install(){
	dobin bin/verifyBamID
}
