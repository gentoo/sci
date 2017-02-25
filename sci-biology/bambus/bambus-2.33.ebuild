# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit perl-module eutils toolchain-funcs

DESCRIPTION="Scaffolding Polymorphic Genomes and Metagenomes, a part of AMOS bundle"
HOMEPAGE="
	http://sourceforge.net/apps/mediawiki/amos/index.php?title=AMOS
	http://sourceforge.net/projects/amos/files/bambus
	http://www.tigr.org/software/bambus"
SRC_URI="
	http://sourceforge.net/projects/amos/files/bambus/${PV}/${P}.tar.gz
	http://mira-assembler.sourceforge.net/docs/scaffolding_MIRA_BAMBUS.pdf"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	sci-biology/tigr-foundation-libs
	dev-perl/XML-Parser
	dev-perl/Config-IniFiles
	dev-perl/GraphViz"
DEPEND="${RDEPEND}"

src_prepare() {
#	epatch "${FILESDIR}"/amos-2.0.8-gcc44.patch
	sed -e 's:BASEDIR = /usr/local/packages/bambus:BASEDIR = /usr:' -i Makefile || die
	sed -e 's:PERL = /usr/local/bin/perl:PERL = /usr/bin/perl:' -i Makefile || die
	sed \
		-e 's:INSTDIR:DESTDIR:g' \
			-i Makefile src/Makefile doc/Makefile || die
	sed -e 's:make all;:make all || exit 255;:' -i src/Makefile || die
	sed \
		-e 's:INSTDIR:DESTDIR:g' \
		-i src/IO/Makefile src/DotLib/Makefile src/grommit/Makefile || die
	sed -e "s:^CC\t=:CC=$(tc-getCXX):" -i Makefile || die
	sed -e "s:^CXX\t=:CXX=$(tc-getCXX):" -i Makefile || die
	sed -e "s:^LD\t:LD=$(tc-getCXX):" -i Makefile || die
	sed -e 's:^AR\t=:#AR=:' -i Makefile || die
	sed -e 's:^export:#export:' -i Makefile || die
	sed -e 's:-Wl::' -i src/grommit/Makefile || die
	# sed -e 's:-L../TIGR_Foundation_CC/:-L../TIGR_Foundation_CC/:' -i src/grommit/Makefile || die
	sed -e 's:make all:make all DESTDIR=$(DESTDIR):' -i Makefile || die
	sed -e 's:make install:make install DESTDIR=$(DESTDIR):' -i Makefile || die
	sed -e "s:# Main targets:LD=$(tc-getCXX):" -i src/grommit/Makefile || die
	sed -e 's:^LDFLAGS =$(STATIC_$(OSTYPE)):LDFLAGS += $(STATIC_$(OSTYPE)):' -i src/grommit/Makefile || die
	sed -e 's:CFLAGS = $(HEADERS) -g:CFLAGS += $(HEADERS) -fPIC:' -i src/grommit/Makefile || die
	sed -e 's:^$ENV{PERLLIB}:$ENV{PERL5LIB}:' -i src/goBambus.pl || die
	sed -e 's:^#!.*:#!/usr/bin/perl:' -i src/goBambus.pl || die
	sed -e 's:^#!.*:#!/usr/bin/perl:' -i src/IO/*.pl || die
	einfo "Argh, cannot delete src/TIGR_Foundation_CC/ because it has some extra files getopt.* not present"
	einfo "in sci-biology/tigr-foundation-libs. It seems bambus-2.33/src/TIGR_Foundation_CC/ contains"
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
	sed -e "s:/export/usr/local:${ED}/usr:g" -i Makefile || die
}

src_compile() {
	emake DESTDIR="${ED}/usr"

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
	emake DESTDIR="${ED}/usr" install
	# cvs HEAD of amos now contains even more updated files: /usr/bin/printScaff /usr/bin/untangle /usr/lib/TIGR/AsmLib.pm
	for f in FASTArecord.pm FASTAreader.pm Foundation.pm FASTAgrammar.pm AsmLib.pm; do rm "${ED}"/usr/lib/TIGR/$f; done || die
	for f in printScaff untangle; do rm "${ED}"/usr/bin/$f; done || die

	# we compiled using locally provided TIGR_Foundation_CC/{cc,.hh} files but
	# link against the libTigrFoundation.a provided by sci-biology/tigr-foundation-libs package
	for f in CategoryInformation.hh MessageLevel.hh ConfigFile.hh LogCategory.hh \
			ConfigSection.hh TIGR_Foundation.hh OptionResult.hh Exceptions.hh \
			LogMsg.hh Options.hh Logger.hh FileSystem.hh; do
				rm "${ED}"/usr/include/$f || die
	done
	rm "${ED}"/usr/lib/libTigrFoundation.a || die

	dodir /usr/share/doc/${P}
	mv "${ED}"/usr/doc/* "${ED}"/usr/share/doc/${PF} || die
	rmdir "${ED}"/usr/doc || die

	dobin "${FILESDIR}"/goBambus.pl
	dodoc "${DISTDIR}"/scaffolding_MIRA_BAMBUS.pdf
	rm -rf "${ED}"/usr/lib || die
}

pkg_postinst(){
	einfo "For manual see http://mira-assembler.sourceforge.net/docs/scaffolding_MIRA_BAMBUS.pdf"
}
