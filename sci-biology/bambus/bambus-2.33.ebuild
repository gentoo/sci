# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

DESCRIPTION="Scaffolding Polymorphic Genomes and Metagenomes, a part of AMOS bundle"
HOMEPAGE="http://sourceforge.net/apps/mediawiki/amos/index.php?title=AMOS
		http://www.tigr.org/software/bambus"
SRC_URI="http://sourceforge.net/projects/amos/files/bambus/2.33/bambus-2.33.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-biology/tigr-foundation-libs"
RDEPEND="${DEPEND}
		dev-lang/perl
		dev-lang/python
		dev-perl/XML-Parser
		dev-perl/Config-IniFiles
		dev-perl/GraphViz"

src_prepare() {
#	epatch "${FILESDIR}"/amos-2.0.8-gcc44.patch
	sed -i 's:BASEDIR = /usr/local/packages/bambus:BASEDIR = /usr:' Makefile || die
	sed -i 's:PERL = /usr/local/bin/perl:PERL = /usr/bin/perl:' Makefile || die
	sed -i 's:INSTDIR:DESTDIR:g' Makefile || die
	sed -i 's:INSTDIR:DESTDIR:g' src/Makefile || die
	sed -i 's:INSTDIR:DESTDIR:g' doc/Makefile || die
	sed -i 's:INSTDIR:DESTDIR:g' src/IO/Makefile || die
	sed -i 's:INSTDIR:DESTDIR:g' src/DotLib/Makefile || die
	sed -i 's:INSTDIR:DESTDIR:g' src/grommit/Makefile || die
	sed -i 's:^CC:#CC:' Makefile || die
	sed -i 's:^CXX:#CXX:' Makefile || die
	sed -i 's:^LD:#LD:' Makefile || die
	sed -i 's:^AR:#AR:' Makefile || die
	sed -i 's:^export:#export:' Makefile || die
	sed -i 's:-Wl::' src/grommit/Makefile || die
	sed -i 's:-L../TIGR_Foundation_CC/:-L../TIGR_Foundation_CC/ -shared -fPIC:' src/grommit/Makefile || die
	sed -i 's:make all:make all DESTDIR=$(DESTDIR):' Makefile || die
	sed -i 's:make install:make install DESTDIR=$(DESTDIR):' Makefile || die
	sed -i 's:^LDFLAGS =$(STATIC_$(OSTYPE)):LDFLAGS += $(STATIC_$(OSTYPE)) -shared -fPIC:' src/grommit/Makefile || die
	sed -i 's:CFLAGS = $(HEADERS) -g:CFLAGS += $(HEADERS):' src/grommit/Makefile || die
	sed -i 's:^$ENV{PERLLIB}:$ENV{PERL5LIB}:' src/goBambus.pl || die
	einfo "Argh, cannot delete src/TIGR_Foundation_CC/ because it has some extra files getopt.* not present"
	einfo "in sci-biology/tigr-foundation-libs. It sees bambus-2.33/src/TIGR_Foundation_CC/ contains"
	einfo "the following 3 files getopt.cc   getopt.hh   getopt1.cc which were possibly copied"
	einfo "over from some old GNU libc and maybe could be completely dropped?"
	einfo "Affected would be:"
	einfo "bambus-2.33/src/grommit/newgrp.cc:#include <getopt.h>"
	einfo "bambus-2.33/src/TIGR_Foundation_CC/Options.hh:#include <getopt.h>"
	einfo "bambus-2.33/src/TIGR_Foundation_CC/Options.hh:#include \"getopt.hh\""
	einfo "bambus-2.33/src/TIGR_Foundation_CC/OptionResult.cc:/*! Uses same syntax as getopt"
	#rm -rf src/TIGR_Foundation_CC || die "Failed to rm -rf src/TIGR_Foundation_CC/, we use it from sci-biology/tigr-foundation-libs"
	#sed -i 's:TIGR_Foundation_CC::' src/Makefile || die "Failed to zap last pointer to local copy of tigr-foundation-libs"
	cd src/TIGR_Foundation_CC || die "Failed to cd src/TIGR_Foundation_CC/"
	epatch "${FILESDIR}"/TigrFoundation-all-patches.patch || die
	sed -i "s:/export/usr/local:${D}/usr:g" Makefile || die
}

src_compile() {
	emake DESTDIR="${D}/usr" || die "emake failed"

	# TODO:
	#ld  -L../TIGR_Foundation_CC/ -shared -fPIC -o grommit grommit.o -L. -lgraph -lTigrFoundation
	# ld: warning: creating a DT_TEXTREL in object.
	#
	# * QA Notice: The following files contain runtime text relocations
	# *  Text relocations force the dynamic linker to perform extra
	# *  work at startup, waste system resources, and may pose a security
	# *  risk.  On some architectures, the code may not even function
	# *  properly, if at all.
	# *  For more information, see http://hardened.gentoo.org/pic-fix-guide.xml
	# *  Please include the following list of files in your report:
	# * TEXTREL usr/bin/grommit
}

src_install() {
	emake DESTDIR="${D}/usr" install || die "emake install failed"
	# cvs HEAD of amos now contains even more updated files: /usr/bin/printScaff /usr/bin/untangle /usr/lib/TIGR/AsmLib.pm
	for f in FASTArecord.pm FASTAreader.pm Foundation.pm FASTAgrammar.pm AsmLib.pm; do rm "${D}"/usr/lib/TIGR/$f; done || die
	for f in printScaff untangle; do rm "${D}"/usr/bin/$f; done || die

	# we compiled using locally provided TIGR_Foundation_CC/{cc,.hh} files but
	# link against the libTigrFoundation.a provided by sci-biology/tigr-foundation-libs package
	for f in CategoryInformation.hh MessageLevel.hh ConfigFile.hh LogCategory.hh \
			ConfigSection.hh TIGR_Foundation.hh OptionResult.hh Exceptions.hh \
			LogMsg.hh Options.hh Logger.hh FileSystem.hh; do \
				rm "${D}"/usr/include/$f; \
	done || die
	rm "${D}"/usr/lib/libTigrFoundation.a || die

	mkdir -p "${D}"/usr/share/doc/"${P}" || die
	mv "${D}"/usr/doc/* "${D}"/usr/share/doc/"${P}" || die
	rmdir "${D}"/usr/doc || die

	dobin "${FILESDIR}"/goBambus.pl || die "Failed to install the alternative of goBambus.py written in perl"
}

pkg_postinst(){
	einfo "For manual see http://mira-assembler.sourceforge.net/docs/scaffolding_MIRA_BAMBUS.pdf"
}
