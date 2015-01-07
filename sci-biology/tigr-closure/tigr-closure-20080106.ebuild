# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit perl-module

DESCRIPTION="TIGR closure tools for the assembly/finishing stage of DNA sequencing projects"
HOMEPAGE="http://tigr-closure.sourceforge.net/"
# http://tigr-closure.svn.sourceforge.net/tigr-closure/
SRC_URI="tigr-closure-svn-20080106.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND=""

src_compile() {
	cd TIGR
	# install the two *.pm files into our perl path?
	cd ..

	# Closure Work Order Processing (CWP - CLOVER)
	# clover and oats
	cd ${WORKDIR}/CWPSystem/trunk/
	# needs TIGR/EUIDService.pm in PERL paths
	make dist
	# how to install the files from install/ ?
	cd ../..
	
	# 
	cd ScaffoldMgmt/trunk
	make dist
	# FIXME: unpack the .tar file into image during src_install()
	cd ../..

	# awfull
	cd ClosureQC/trunk/
	mkdir sandbox
	${SANDBOX}=${WORKDIR}/sandbox
	# have ./src/, ./doc, ./install, ./test/work/drivers, ./test/work/getqc, ./test/tmp
	cd test
	# ...
	cd ../../..

	# 
	cd ClosureReactionSystem/trunk
	make BUILD=true
	cd ../..

	# some Java servlet?
	cd AserverConsoleEJB3Hibernate
	# huh?
	cd ../..
}

src_install() {
	cd ${WORKDIR}/SequenceTiling
	dobin trunk/src/*.pl
	cd trunk/src/TIGR/SequenceTiling/
	myinst="DESTDIR=${D}"
	perl-module_src_install
	#
}
