# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit perl-module

DESCRIPTION="TIGR closure tools for the assembly/finishing stage of DNA sequencing projects"
HOMEPAGE="http://tigr-closure.sourceforge.net/"
# http://tigr-closure.svn.sourceforge.net/tigr-closure/
SRC_URI="tigr-closure-svn-20080106.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND=""

src_compile() {

	# Closure Work Order Processing (CWP - CLOVER)
	# clover and oats
	cd "${WORKDIR}"/CWPSystem/trunk/ || die
	# needs TIGR/EUIDService.pm in PERL paths
	emake dist
	# how to install the files from install/ ?
	cd ../.. || die

	#
	cd ScaffoldMgmt/trunk || die
	emake dist
	# FIXME: unpack the .tar file into image during src_install()
	cd ../.. || die

	# awfull
	cd ClosureQC/trunk/ || die
	mkdir sandbox || die
	${SANDBOX}="${WORKDIR}"/sandbox
	# have ./src/, ./doc, ./install, ./test/work/drivers, ./test/work/getqc, ./test/tmp
	cd test || die
	# ...
	cd ../../.. || die

	#
	cd ClosureReactionSystem/trunk || die
	emake BUILD=true
	cd ../.. || die

	# some Java servlet?
	cd AserverConsoleEJB3Hibernate || die
	# huh?
	cd ../.. || die
}

src_install() {
	cd "${WORKDIR}"/SequenceTiling || die
	dobin trunk/src/*.pl
	cd trunk/src/TIGR/SequenceTiling/ || die
	myinst="DESTDIR=${D}"
	perl-module_src_install
	#
}
