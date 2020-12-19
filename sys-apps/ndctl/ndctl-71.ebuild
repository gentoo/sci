# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools bash-completion-r1 linux-info systemd

DESCRIPTION="utility for managing the nvdimm sub-system in the linux kernel"
HOMEPAGE="https://pmem.io"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pmem/ndctl"
else
	SRC_URI="https://github.com/pmem/ndctl/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
RESTRICT="test"

RDEPEND="
	dev-libs/json-c
	sys-apps/keyutils
	sys-apps/kmod
	sys-apps/util-linux
	virtual/udev
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/asciidoc
	app-text/xmlto
	virtual/pkgconfig
"

CONFIG_CHECK="~BLK_DEV_RAM_DAX ~FS_DAX ~X86_PMEM_LEGACY ~LIBNVDIMM ~BLK_DEV_PMEM \
~ARCH_HAS_PMEM_API ~TRANSPARENT_HUGEPAGE ~MEMORY_HOTPLUG ~MEMORY_HOTREMOVE \
~ZONE_DEVICE ~FS_DAX_PMD"

src_prepare() {
	"${S}"/git-version-gen
	default
	eautoreconf
}

src_configure() {
	econf \
	  --disable-asciidoctor \
	  --without-bash \
	  --without-systemd \
	  --with-keyutils
}

src_install() {
	emake DESTDIR="${D}" install

	dobashcomp contrib/${PN}
	systemd_dounit ${PN}/ndctl-monitor.service
}
