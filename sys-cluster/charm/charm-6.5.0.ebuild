# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils flag-o-matic fortran-2 multilib toolchain-funcs

DESCRIPTION="Message-passing parallel language and runtime system"
HOMEPAGE="http://charm.cs.uiuc.edu/"
SRC_URI="http://charm.cs.uiuc.edu/distrib/${P}.tar.gz"

LICENSE="charm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cmkopt charmshared tcp smp doc"

DEPEND="
	doc? (
	>=app-text/poppler-0.12.3-r3[utils]
	dev-tex/latex2html
	virtual/tex-base )"
RDEPEND=""

case ${ARCH} in
	x86)
		CHARM_ARCH="net-linux" ;;

	amd64)
		CHARM_ARCH="net-linux-amd64" ;;
esac

FORTRAN_STANDARD="90"

src_prepare() {
	#epatch "${FILESDIR}"/${P}-gcc-4.7.patch

	# For production, disable debugging features.
	CHARM_OPTS="--with-production"

	# TCP instead of default UDP for socket comunication
	# protocol
	if use tcp; then
		CHARM_OPTS="${CHARM_OPTS} tcp"
	fi

	# enable direct SMP support using shared memory
	if use smp; then
		CHARM_OPTS="${CHARM_OPTS} smp"
	fi

	# CMK optimization
	if use cmkopt; then
		append-flags -DCMK_OPTIMIZE=1
	fi

	sed \
		-e "/CMK_CF90/s:f90:${FC}:g" \
		-e "/CMK_CXX/s:g++:$(tc-getCXX):g" \
		-e "/CMK_CC/s:gcc:$(tc-getCC):g" \
		-e '/CMK_F90_MODINC/s:-p:-I:g' \
		-e "/CMK_LD/s:\"$: ${LDFLAGS} \":g" \
		-i src/arch/net-linux*/*sh

	sed \
		-e "s:\(-o conv-cpm\):${LDFLAGS} \1:g" \
		-e "s:\(-o charmxi\):${LDFLAGS} \1:g" \
		-e "s:\(-o charmrun-silent\):${LDFLAGS} \1:g" \
		-e "s:\(-o charmrun-notify\):${LDFLAGS} \1:g" \
		-e "s:\(-o charmrun\):${LDFLAGS} \1:g" \
		-e "s:\(-o charmd_faceless\):${LDFLAGS} \1:g" \
		-e "s:\(-o charmd\):${LDFLAGS} \1:g" \
		-i \
		src/scripts/Makefile \
		src/arch/net/charmrun/Makefile

	append-cflags -DALLOCA_H

	echo "charm opts: ${CHARM_OPTS}"
}

src_compile() {
	# build charmm++ first
	./build charm++ ${CHARM_ARCH} ${CHARM_OPTS} ${MAKEOPTS} ${CFLAGS} || \
		die "Failed to build charm++"

	# make charmc play well with gentoo before
	# we move it into /usr/bin
	epatch "${FILESDIR}/charm-6.5.0-charmc-gentoo.patch"

	# make pdf/html docs
	if use doc; then
		cd "${S}"/doc
		make doc || die "failed to create pdf/html docs"
	fi
}

src_install() {
	sed -e "s|gentoo-include|${P}|" \
		-e "s|gentoo-libdir|$(get_libdir)|g" \
		-e "s|VERSION|${P}/VERSION|" \
		-i ./src/scripts/charmc || die "failed patching charmc script"

	# In the following, some of the files are symlinks to ../tmp which we need
	# to dereference first (see bug 432834).

	# Install binaries.
	for i in bin/*; do
		if [ -L $i ]; then
			i=$( readlink -e $i )
		else
			i=$i
		fi
		dobin $i
	done

	# Install headers.
	insinto /usr/include/${P}
	for i in include/*; do
		if [ -L $i ]; then
			i=$( readlink -e $i )
		else
			i=$i
		fi
		doins $i
	done

	# Install static libs.  Charm has a lot of .o "libs" that it requires at
	# runtime.
	for i in lib/*.{a,o}; do
		if [ -L $i ]; then
			i=$( readlink -e $i )
		else
			i=$i
		fi
		dolib $i
	done

	# Install shared libs.
	if use charmshared; then
		cd "${S}"/lib_so
		dolib.so *.so*
	fi

	# Basic docs.
	dodoc CHANGES README

	# Install examples.
	find examples/ -name 'Makefile' | xargs sed \
		-r "s:(../)+bin/charmc:/usr/bin/charmc:" -i || \
		die "Failed to fix examples"
	find examples/ -name 'Makefile' | xargs sed \
		-r "s:./charmrun:./charmrun ++local:" -i || \
		die "Failed to fix examples"
	insinto /usr/share/doc/${PF}/examples
	doins -r examples/charm++/*

	# Install pdf/html docs
	if use doc; then
		cd "${S}"/doc
		# Install pdfs.
		insinto /usr/share/doc/${PF}/pdf
		doins  doc/pdf/*
		# Install html.
		docinto html
		dohtml -r doc/html/*
	fi
}

pkg_postinst() {
	echo
	einfo "Please test your charm installation by copying the"
	einfo "content of /usr/share/doc/${PF}/examples to a"
	einfo "temporary location and run 'make test'."
	echo
}
