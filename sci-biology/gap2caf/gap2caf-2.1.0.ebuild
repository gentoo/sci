# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils

DESCRIPTION="GAP4 file format to CAF v2 format converter for genomic assembly data"
HOMEPAGE="http://www.sanger.ac.uk/resources/software/caf/"
SRC_URI="
	ftp://ftp.sanger.ac.uk/pub/PRODUCTION_SOFTWARE/src/gap2caf-2.1.0.tar.gz
	http://downloads.sourceforge.net/staden/staden-2.0.0b8.tar.gz"

LICENSE="GRL staden"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	sci-biology/staden
	>=dev-lang/tcl-8.5:0="
RDEPEND="${DEPEND}"

#src_prepare(){
#	epatch "${FILESDIR}"/Makefile.in-"${PV}".patch || die
#}

src_prepare(){
	sed -i 's:/include/tcl8.4:/include:' configure.ac || die
	sed -i 's:libtcl8.4:libtcl:' configure.ac || die
	sed \
		-e 's:tcl8.4:tcl:' \
		-e 's:pkglib_PROGRAMS:pkglibexec_PROGRAMS:g' \
		-i src/Makefile.am || die
	eautoreconf
	sed -i 's:/include/tcl8.4:/include:' configure || die
	sed -i 's:libtcl8.4:libtcl:' configure || die
}

src_configure(){
	# STADENROOT=/usr is used to find $STADENROOT/lib/staden/staden.profile and staden_config.h
	# STADENSRC is used to locate gap4/IO.h
	#CPPFLAGS="$CPPFLAGS -I/home/mmokrejs/proj/staden/staden/trunk/src" \
	#LDFLAGS="$LDFLAGS -L/usr/lib/staden -lmutlib -lprimer3 -lg -lmisc" \
	# STADENROOT=/usr/share/staden \
	# STADENSRC="${WORKDIR}"/staden-2.0.0b8-src \
	econf \
		--with-stadenroot=/usr \
		--with-tcl=/usr \
		--with-stadensrc="${WORKDIR}"/staden-2.0.0b8-src
	#sed -i 's:prefix = /usr:prefix = $(DESTDIR)/usr:' Makefile || die
	#sed -i 's:prefix = /usr:prefix = $(DESTDIR)/usr:' src/Makefile || die
	sed -i 's:tcl8.4:tcl:' src/Makefile || die

	# The below tricks in overall do not help, only for -ltk_utils somehow
	sed -i 's:-ltk_utils:-Wl,--enable-new-dtags -Wl,-rpath,/usr/lib/staden -ltk_utils -rpath-link:' src/Makefile || die
	sed -i 's:-lgap:-Wl,--enable-new-dtags -Wl,-rpath,/usr/lib/staden -lgap:' src/Makefile || die
	sed -i 's:-lseq_utils:-Wl,--enable-new-dtags -Wl,-rpath,/usr/lib/staden -lseq_utils:' src/Makefile || die
	sed -i 's:-rpath-link::' src/Makefile || die
}

# TODO: the 2.0.2 archive lacks manpages compared to 2.0, FIXME
# The man/Makefile.in is screwed in 2.0.2 so we cannot use it to install the manpage files,
# not even copying over whole caftools-2.0/man/ to caftools-2.0.2/man does not help.
src_install(){
	# do not use upstream's install it just install shell wrapper into /usr/bin/gap2caf
	# calling "LD_LIBRARY_PATH=/usr/lib/staden /usr/lib/gap2caf/gap2caf $@"
	# emake install DESTDIR="${D}" || die
	#
	# Instead, we rely on sci-biology/staden providind /etc/env.d/99staden file providing LDPATH=/usr/lib/staden
	dobin src/gap2caf
	dodoc README
}

# BUG #259848
# A working ebuild which needs some files from staden source tree. That is ugly,
# am sorting out with upstream how to get around in a clean way.
