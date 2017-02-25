# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

PYTHON_COMPAT=( python{2_6,2_7} )

DESCRIPTION="Estimate best k-mer length to be used in novo assemblies"
HOMEPAGE="http://kmergenie.bx.psu.edu/"
SRC_URI="http://kmergenie.bx.psu.edu/"${P}".tar.gz"

LICENSE="CeCILL-1.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# dev-python/docopt[${PYTHON_USEDEP}]
DEPEND="dev-python/docopt
	dev-lang/R"
RDEPEND="${DEPEND}"

# Type `make` in the KmerGenie directory
# To enable larger values of k, e.g. 200, type `make clean ; make k=200`.
#
# usage: ./kmergenie reads_file

src_prepare(){
	sed -e 's#-O4##' -i makefile || die
	sed -e 's#third_party.##' -i kmergenie || die
}

src_compile(){
	make -j 1 || die
}

src_install(){
	dobin kmergenie specialk
	dodoc README
	# TODO: install also the python files
	insinto /usr/share/${PN}/R
	doins scripts/*
}
