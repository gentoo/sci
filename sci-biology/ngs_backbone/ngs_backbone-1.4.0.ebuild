# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Assembly & annotation pipeline with web interface for EST/chromosomal sequences"
HOMEPAGE="http://bioinf.comav.upv.es/ngs_backbone/index.html"
SRC_URI="http://bioinf.comav.upv.es/_downloads/"${P}".tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sci-biology/biopython[${PYTHON_USEDEP}]
	sci-biology/samtools[${PYTHON_USEDEP}]
	sci-biology/picard
	sci-biology/mira
	sci-biology/bwa
	sci-biology/gatk
	sci-biology/pysam[${PYTHON_USEDEP}]
	sci-biology/estscan
	sci-biology/ncbi-tools
	sci-biology/lucy
	sci-biology/gmap
	sci-biology/emboss
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/psubprocess[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]"
	# ( blast2GO || b2g4pipe )
	# sci-biology/sputnik
	# sci-biology/gsnap

# blast2GO is http://www.blast2go.org/home
# a non-GUI pipeline is called b2g4pipe, see https://sites.google.com/a/brown.edu/bioinformatics-in-biomed/b2g4pipe-2-5

# TODO: drop the bundled binaries but ...
# 1. the QA check did not find all bundled binaries, e.g. sputnik, lucy, trimpoly
# 2. until we have them all, maybe keep the installed
#
# * QA Notice: The following files contain writable and executable sections
# *  Files with such sections will not work properly (or at all!) on some
# *  architectures/operating systems.  A bug should be filed at
# *  http://bugs.gentoo.org/ to make sure the issue is fixed.
# *  For more information, see http://hardened.gentoo.org/gnu-stack.xml
# *  Please include the following list of files in your report:
# *  Note: Bugs should be filed for the respective maintainers
# *  of the package in question and not hardened@g.o.
# * RWX --- --- usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/tblastx
# * RWX --- --- usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/makeblastdb
# * RWX --- --- usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/blastx
# * RWX --- --- usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/blastp
# * RWX --- --- usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/tblastn
# * RWX --- --- usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/blastn
# * RWX --- --- usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/tblastx
# * RWX --- --- usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/makeblastdb
# * RWX --- --- usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/blastx
# * RWX --- --- usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/blastp
# * RWX --- --- usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/tblastn
# * RWX --- --- usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/blastn

#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/bgzip
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/blastn
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/blastp
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/blastx
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/bwa
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/emboss_data
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/emboss_data/EBLOSUM62
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/emboss_data/EDNAFULL
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/emboss_data/codes.english
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/emboss_data/est2genome.acd
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/emboss_data/knowntypes.standard
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/emboss_data/water.acd
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/est2genome
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/estscan
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/fa_coords
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/gmap
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/gmap_build
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/gmap_compress
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/gmap_process
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/gmap_reassemble
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/gmap_setup
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/gmap_uncompress
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/gmapindex
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/gsnap
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/gsnap_tally
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/lucy
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/makeblastdb
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/md_coords
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/mdust
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/samtools
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/sputnik
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/tabix
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/tblastn
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/tblastx
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/trimpoly
#/usr/lib64/python2.7/site-packages/ext/bin/linux/32bit/water
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/bgzip
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/blastn
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/blastp
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/blastx
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/bwa
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/emboss_data
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/emboss_data/EBLOSUM62
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/emboss_data/EDNAFULL
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/emboss_data/codes.english
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/emboss_data/est2genome.acd
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/emboss_data/knowntypes.standard
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/emboss_data/water.acd
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/est2genome
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/estscan
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/fa_coords
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/gmap
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/gmap_build
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/gmap_compress
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/gmap_process
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/gmap_reassemble
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/gmap_setup
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/gmap_uncompress
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/gmapindex
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/gsnap
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/gsnap_tally
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/lucy
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/makeblastdb
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/md_coords
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/mdust
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/samtools
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/sputnik
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/tabix
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/tblastn
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/tblastx
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/trimpoly
#/usr/lib64/python2.7/site-packages/ext/bin/linux/64bit/water

pkg_postinst(){
	einfo "It is highly recommended to install blast2GO. Either the commercial version with GUI"
	einfo "   or a non-GUI version called b2g4pipe. Either way, refer to http://www.blast2go.org"
	einfo "   Brief installation process is at http://bioinf.comav.upv.es/ngs_backbone/install.html"
	einfo "Alternatively, a VirtualBox image with ngs_bakbone is at http://bioinf.comav.upv.es/_downloads/ngs_machine_v3.tar.gz"
}
