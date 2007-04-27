# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P=GlimmerHMM

DESCRIPTION="An eukaryotic gene finding system from TIGR"
HOMEPAGE="http://www.cbcb.umd.edu/software/GlimmerHMM/"
SRC_URI="ftp://ftp.cbcb.umd.edu/pub/software/glimmerhmm/${MY_P}-${PV}.tar.gz"

LICENSE="Artistic"
SLOT="0"
IUSE=""
KEYWORDS="~x86"

DEPEND=""
RDEPEND=""

S=${WORKDIR}/${MY_P}

src_compile() {
	sed -i -e 's|\(my $scriptdir=\)$FindBin::Bin|\1"/usr/share/'${PN}'/training_utils"|' \
		-e 's|\(use lib\) $FindBin::Bin|\1 "/usr/share/'${PN}'/lib"|' train/trainGlimmerHMM || die "sed failed"
	sed -i 's/^CFLAGS[ ]*=.*//' */makefile

	cd sources
	emake || die "emake failed in sources"
	cd "${S}/train" || die "failed to cd"
	emake || die "emake failed in train"
}

src_install() {
	dobin sources/glimmerhmm train/trainGlimmerHMM

	dodir /usr/share/${PN}/{lib,models,training_utils}
	insinto /usr/share/${PN}/lib
	doins train/*.pm
	insinto /usr/share/${PN}/models
	doins -r trained_dir/*
	insinto /usr/share/${PN}/training_utils
	insopts -m755
	doins train/{build{1,2,-icm,-icm-noframe},erfapp,falsecomp,findsites,karlin,score,score{2,ATG,ATG2,STOP,STOP2},splicescore}

	dodoc README.first train/readme.train
}
