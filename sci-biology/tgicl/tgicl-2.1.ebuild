# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-module

DESCRIPTION="TIGR perl scripts for clustering large EST/mRNAs datasets and aceconv, mgblast and pvmsx binaries"
HOMEPAGE="http://sourceforge.net/projects/tgicl"
SRC_URI="http://sourceforge.net/projects/tgicl/files/tgicl%20v2.1/TGICL-2.1.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-perl/Module-Build
	sci-biology/cap3-bin
	sci-biology/ncbi-tools
	sci-biology/cdbfasta
	sci-biology/clview
	sci-biology/nrcl
	sci-biology/psx
	sci-biology/sclust
	sci-biology/seqclean
	sci-biology/tclust
	sci-biology/zmsort"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/TGICL-2.1

# ignore these binaries: mdust, psx, sclust, tclust, zmsort
# cdbyank and cdbfasta I think were updated by the author more than once. I am not sure if he has updated the tgi-tools package as well. I can compare the cdbfasta tool with the ones in tgi-tools and see if I find any diffs.

# Also cap3 was a problem because for a long time there was no package for it and it is not an OS product. We got author agreement that we can redistribute his binaries along with tgicl code. From what I see you have a package. It would be great if I can make tgicl depend on a cap3 package at some point. I have to check debian/rh though.

# On a same note, there is a ncbi package and tgicl should depend on that. There is however a problem with mgblast. Old time ago, in a galaxy far, far away, some dark sith lord made a patch for it, patch that never made it back to ncbi developers. Meanwhile ncbi tools kept evolving and the patch is now obsolete and it may break the code. However I hope to entirely drop mgblast for the next tgicl release. I also hope to slowly phase out tclust, sclust, cdbfasta, cdbyank, zmsort, psx, tgicl_asm.psx and tgicl_cluster.psx. 

src_install(){
	./Build install || die "Failed to execute ./Build install"
	einfo "We have to use the mgblast binary provided by upstream because it cannot be compiled against newer ncbi-tools anymore"
	einfo "We also keep pvmsx binary because the pvmsx package needs pvm3.h header which is probably the one from pvm bundle which is not in portage at all, contact sys-cluster herd"
	for f in mdust psx sclust tclust nrcl zmsort cap3 formatdb cdbfasta cdbyank; do rm -f "${D}"/usr/bin/$f || die "Cannot delete ${D}"/usr/bin/"$f"; done

	# fix first lines of teh script to use /usr/bin/perl instead of /usr/bin/perl-$version
	for f in tgicl tgicl_asm.psx tgicl_asmpta.psx tgicl_cluster.psx; do
		sed -i 's@^#!/usr/bin/perl-*@#! /usr/bin/perl@' "${D}"/usr/bin/$f || die "Failed to fix ${D}"/usr/bin/"$f";
	done
}
