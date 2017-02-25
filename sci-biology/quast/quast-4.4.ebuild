# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="Compare quality of multiple genome assemblies to each other"
HOMEPAGE="http://bioinf.spbau.ru/QUAST"
SRC_URI="http://sourceforge.net/projects/quast/files/${P}.tar.gz"

LICENSE="GPL-2" # and some other for the bundled copies, see http://quast.bioinf.spbau.ru/LICENSE
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	sci-biology/mummer
	sci-biology/glimmerhmm"
#	sci-biology/GAGE
#	sci-biology/GeneMarkS
#   sci-biology/GeneMarkES
#	sci-biology/MetaGeneMark
#   sci-biology/ncbi-tools++
#
# comes with bundled executables in ./quast_libs

# the above packages need to be created first

RDEPEND="${DEPEND}"

src_install(){
	python_foreach_impl python_newscript quast.py quast
	python_foreach_impl python_newscript metaquast.py metaquast
	python_foreach_impl python_newscript icarus.py icarus

	dodoc manual.html

	# TODO: install quast_libs/ subdirectory contents into some PATH and PYTHON_PATH
	# TODO: unbundle bundled executables
}
