# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils toolchain-funcs

MYP="${PN}-src-${PV}"

DESCRIPTION="Thin wrapper around FFmpeg"
HOMEPAGE="http://code.google.com/p/avbin/"
SRC_URI="http://avbin.googlecode.com/files/${MYP}.tar.gz"

LICENSE="|| ( GPL-3 LGPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=media-video/ffmpeg-0.5"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${MYP}"

src_prepare() {
	# patch for ffmpeg-0.5 to work (suppress SAMPLE_FMT_S24)
	epatch "${FILESDIR}"/${P}-ffmpeg05.patch
}

src_compile() {
	# ffmpeg_revision is taken from git repo at about ffmpeg-0.5 (harmless)
	# makefile is not used
	$(tc-getCC) ${CFLAGS} -fPIC \
		-DAVBIN_VERSION=${PV} -Iinclude \
		-DFFMPEG_REVISION=17762 \
		$(pkg-config --cflags libavformat libavcodec libavutil libswscale) \
		-c src/avbin.c -o avbin.o \
		|| die "compiling avbin failed"
	$(tc-getCC) ${LDFLAGS} -shared -Wl,-soname,libavbin.so.${PV} \
		avbin.o -o libavbin.so.${PV} \
		$(pkg-config --libs libavformat libavcodec libavutil libswscale) \
		|| die "linking avbin failed"
	ln -s libavbin.so.${PV} libavbin.so
	if use doc; then
		doxygen Doxyfile || die "doxygen failed"
	fi
}

src_install() {
	dolib.so libavbin.so* || die
	insinto /usr/include
	doins include/avbin.h || die
	dodoc CHANGELOG README
	if use doc; then
		dohtml doc/html/* || die
	fi
}
