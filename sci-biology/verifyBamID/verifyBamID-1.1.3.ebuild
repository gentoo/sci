# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Verify sample identity/mix and genotype concordance"
HOMEPAGE="http://genome.sph.umich.edu/wiki/VerifyBamID"
SRC_URI="https://github.com/statgen/verifyBamID/archive/v1.1.3.tar.gz -> ${P}.tar.gz
	https://github.com/statgen/libStatGen/archive/v1.0.13.tar.gz -> libStatGen-1.0.13.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# DEPEND="sci-libs/libStatGen" # TODO: currently it uses its own bundled copy
DEPEND=""
RDEPEND="${DEPEND}"

src_prepare(){
	# unpack ./libStatGen-1.0.13/ contents
	gzip -dc "${DISTDIR}"/libStatGen-1.0.13.tar.gz | tar xf - || die
	ln -s libStatGen-1.0.13 libStatGen || die
	cd "${WORKDIR}" || die
	ln -s libStatGen-1.0.13 libStatGen || die
	sed -e 's/-Werror//' -i verifyBamID-1.1.3/src/Makefile || die
	sed -e 's/-Werror//' -i verifyBamID-1.1.3/libStatGen-1.0.13/general/Makefile || die
	eapply_user
}

src_compile(){
	# LIB_PATH_GENERAL="${EPREFIX}"/usr/"$(get_libdir)" emake
	LIB_PATH_GENERAL="../libStatGen-1.0.13" emake USER_WARNINGS=' '
}

src_install(){
	dobin bin/verifyBamID
}
