# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

[ "$PV" == "9999" ] && inherit git-2

DESCRIPTION="Bayesian gen. variant detector to find small polymorphisms: SNPs, indels, MNPs and complex events"
HOMEPAGE="https://github.com/ekg/freebayes"
EGIT_REPO_URI="git://github.com/ekg/freebayes.git"

# need top checkout vcflib/ as well
#
# To build freebayes you must use git to also download its submodules.
#   Do so by downloading freebayes again using this command (note --recursive flag):
#   git clone --recursive git://github.com/ekg/freebayes.git
#

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sci-biology/bamtools
	sci-biology/samtools"
