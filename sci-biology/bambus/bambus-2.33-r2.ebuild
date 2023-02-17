# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module toolchain-funcs

DESCRIPTION="Scaffolding Polymorphic Genomes and Metagenomes, a part of AMOS bundle"
HOMEPAGE="
	https://sourceforge.net/apps/mediawiki/amos/index.php?title=AMOS
	https://sourceforge.net/projects/amos/files/bambus"
SRC_URI="
	https://sourceforge.net/projects/amos/files/bambus/${PV}/${P}.tar.gz
	https://mira-assembler.sourceforge.net/docs/scaffolding_MIRA_BAMBUS.pdf"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	sci-biology/tigr-foundation-libs
	dev-perl/XML-Parser
	dev-perl/Config-IniFiles
	dev-perl/GraphViz"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/TigrFoundation-all-patches.patch
)

src_prepare() {
	default
#	eapply "${FILESDIR}"/amos-2.0.8-gcc44.patch
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
}

src_install() {
	pushd src/TIGR_Foundation_CC || die
	sed -e "s:/export/usr/local:${ED}/usr:g" -i Makefile || die
	popd || die
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

	dodir /usr/share/doc/${PF}
	mv "${ED}"/usr/doc/* "${ED}"/usr/share/doc/${PF} || die
	rmdir "${ED}"/usr/doc || die

	dobin "${FILESDIR}"/goBambus.pl
	dodoc "${DISTDIR}"/scaffolding_MIRA_BAMBUS.pdf
	rm -r "${ED}"/usr/lib || die
}

pkg_postinst(){
	einfo "For manual see http://mira-assembler.sourceforge.net/docs/scaffolding_MIRA_BAMBUS.pdf"
}
