# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module toolchain-funcs

DESCRIPTION="iscan (aka twinscan and N-SCAN), Pairagon wrapper: Gene structure pred. pipeline"
HOMEPAGE="https://mblab.wustl.edu/software.html"
#SRC_URI="https://mblab.wustl.edu/software/download/iscan-${PV}.tar_.gz -> ${P}.tar.gz"
# ERROR: cannot verify mblab.wustl.edu's certificate, issued by ‘CN=InCommon RSA Server CA,OU=InCommon,O=Internet2,L=Ann Arbor,ST=MI,C=US’:
# Unable to locally verify the issuer's authority.
# To connect to mblab.wustl.edu insecurely, use `--no-check-certificate'.
SRC_URI="iscan-${PV}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/glib:2"
RDEPEND="${DEPEND}"

S="${WORKDIR}/N-SCAN"
RESTRICT="test fetch"

src_prepare() {
	default
	sed "1 a use lib '/usr/share/${PN}/lib/perl5';" -i "${S}"/bin/*.pl || die
	sed '/my $blast_param/ s/#//' -i "${S}/bin/runTwinscan2.pl" || die
	tc-export CC AR RANLIB

	sed \
		-e 's:ar :$(AR) :g' \
		-e 's:ranlib :$(RANLIB) :g' \
		-e 's: -o : $(LDFLAGS) -o :g' \
		-i Makefile || die

	sed \
		-e "/^GLIB_CFLAGS/s:=.*:=$($(tc-getPKG_CONFIG) --cflags glib-2.0) -DHAS_GLIB:g" \
		-e "/^GLIB_LFLAGS/s:=.*:=$($(tc-getPKG_CONFIG) --libs glib-2.0) -DHAS_GLIB:g" \
		-i Makefile.include || die
}

src_install() {
	# TODO: prevent file collision with media-gfx/iscan by renaming iscan to iscan_twinscan
	# also fix a Genscan++ToZoe.pl Nscan_driver.pl runTwinscan2.pl run_iscan.pl run_iscan_cons.pl run_iscan_cons_list.pl test.pl
	rm src/test.pl || die
	dobin bin/iscan bin/zoe2gtf bin/*.pl src/*.pl
	dolib.so lib/libzoe.a
	insinto /usr/share/${PN}
	doins -r parameters
	insinto /usr/share/${PN}/src
	doins src/*.zhmm
	perl_set_version
	perl_domodule lib/perl5/*.pm
	echo "TWINSCAN=/usr" > "${S}"/99${PN}
	doenvd "${S}"/99${PN}
	rm -rf examples/tmp
	dodoc examples/* README* src/doc/*.txt
}

pkg_postinst(){
	einfo "Pairagon acts on output from either: sci-biology/gmap sci-biology/blat."
	einfo "It also works on blastn output from WU-BLAST (not provided in Gentoo)."
	einfo "It also calls blastz (seems superseded by LASTZ) and genscan++ (not provided in Gentoo)."
	einfo "For some reason we have pslCDnaFilter provided only by sci-biology/ucsc-genome-browser"
}
