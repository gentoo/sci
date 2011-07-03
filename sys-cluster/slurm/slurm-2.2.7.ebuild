# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils pam

DESCRIPTION="SLURM: A Highly Scalable Resource Manager"
HOMEPAGE="https://computing.llnl.gov/linux/slurm/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="munge mysql pam postgres ssl static-libs"

DEPEND="
	mysql? ( dev-db/mysql )
	munge? ( sys-auth/munge )
	pam? ( virtual/pam )
	postgres? ( dev-db/postgresql-base )
	ssl? ( dev-libs/openssl )
	>=sys-apps/hwloc-1.1.1-r1
	>=sys-process/numactl-2.0.6"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup slurm
	enewuser slurm -1 -1 /var/spool/slurm slurm
}

src_configure() {
	local myconf=(
			--sysconfdir="${EPREFIX}/etc/${PN}"
			--with-hwloc="${EPREFIX}/usr"
			)
	use pam && myconf+=( --with-pam_dir=$(getpam_mod_dir) )
	use mysql && myconf+=( --with-mysql_config="${EPREFIX}/usr/bin/mysql_config" )
	use postgres && myconf+=( --with-pg_config="${EPREFIX}/usr/bin/pg_config" )
	econf "${myconf[@]}" \
		$(use_enable pam) \
		$(use_with ssl) \
		$(use_with munge) \
		$(use_enable static-libs static)
}

src_compile() {
	default
	use pam && emake -C contribs/pam || die
}

src_install() {
	default
	use pam && emake DESTDIR="${D}" -C contribs/pam install || die
	use static-libs || find "${ED}" -name '*.la' -exec rm {} +
}
