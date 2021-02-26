# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools linux-info

DESCRIPTION="user extensible heap manager built on top of jemalloc"
HOMEPAGE="https://memkind.github.io/memkind/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/memkind/memkind"
else
	SRC_URI="https://github.com/memkind/memkind/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="+heap-manager openmp secure +tls"
RESTRICT="test"

DEPEND="
	sys-apps/ndctl
	sys-process/numactl
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
	cd jemalloc && eautoreconf
}

src_configure() {
	local myconf=(
		--disable-silent-rules
		--enable-shared
		--enable-static
		--enable-daxctl
		$(use_enable heap-manager)
		$(use_enable openmp)
		$(use_enable secure)
		$(use_enable tls)
	)
	econf "${myconf[@]}"
}

src_test() {
	addwrite /proc/sys/vm/nr_hugepages
	echo 3000 > /proc/sys/vm/nr_hugepages
	emake check
}
