# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit unpacker wrapper xdg

DESCRIPTION="Software for plasmid mapping, primer design, and restriction site analysis"
HOMEPAGE="https://www.snapgene.com/features"
SRC_URI="snapgene_${PV}_linux.deb"
SNAPGENE_DOWNLOAD="https://www.snapgene.com/local/targets/download.php?os=linux_deb&variant=paid&release=${PV}"
RESTRICT="fetch"

LICENSE="GSL"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
# ldd /opt/gslbiotech/snapgene/snapgene
RDEPEND="${DEPEND}
	app-arch/bzip2
	app-arch/xz-utils
	app-crypt/qca[qt6]
	dev-libs/openssl-compat:1.1.1
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[concurrent,gui,network,opengl,sql,widgets,xml]
	dev-qt/qtdeclarative:6
	dev-qt/qtpositioning:6
	dev-qt/qtwebchannel:6
	dev-qt/qtwebengine:6
	media-libs/libglvnd
	media-libs/tiff-compat:4
	sci-libs/htslib:0/3
	sys-devel/gcc
	sys-libs/glibc
	llvm-runtimes/libcxx[libcxxabi]
	sys-libs/libunwind:0/8
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libxcb
"
BDEPEND=">=dev-util/patchelf-0.10"

S="${WORKDIR}"
QA_PREBUILT="*"

pkg_nofetch() {
	elog "Please download ${SRC_URI} from"
	elog "${SNAPGENE_DOWNLOAD}"
	elog "and place it into your DISTDIR directory."
}

src_install() {
	patchelf --replace-needed libunwind.so.1 libunwind.so.8 \
		opt/gslbiotech/snapgene/snapgene || die

	mv usr/share/doc/snapgene usr/share/doc/${PF} || die
	gzip -d usr/share/doc/${PF}/changelog.Debian.gz || die

	insinto /
	doins -r *

	fperms +x /opt/gslbiotech/snapgene/snapgene{,.sh}
	make_wrapper ${PN} ./snapgene.sh /opt/gslbiotech/snapgene/
}
