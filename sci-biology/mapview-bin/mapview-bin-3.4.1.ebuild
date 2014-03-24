# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Display single-end and pair-end short reads (faster than consed, hawkeye, eagleview)"
HOMEPAGE="http://evolution.sysu.edu.cn/mapview/"
SRC_URI="http://evolution.sysu.edu.cn/software/mapview.rar
		http://evolution.sysu.edu.cn/mapview/MVF.pdf"

# example datasets
# http://evolution.sysu.edu.cn/mapview/small_exam.tar.gz
# http://evolution.sysu.edu.cn/mapview/pair_exam.tar.gz
# http://bioinformatics.oxfordjournals.org/content/25/12/1554.full

# snapshots of the website
# http://archive.is/evolution.sysu.edu.cn

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
		dev-lang/mono"

src_install(){
	echo "#! /bin/sh" > MapView
	echo "mono `which MapView.exe` $*" >> MapView
	dobin MapView MapView.exe
	dodoc MVFmaker_NewFormat.txt readme.txt "${DISTDIR}"/MVF.pdf
}
