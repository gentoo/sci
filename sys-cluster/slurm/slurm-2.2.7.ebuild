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
IUSE="munge mysql pam +pbs-compat postgres ssl static-libs"

DEPEND="
	mysql? ( dev-db/mysql )
	munge? ( sys-auth/munge )
	pam? ( virtual/pam )
	pbs-compat? ( !sys-cluster/torque )
	postgres? ( dev-db/postgresql-base )
	ssl? ( dev-libs/openssl )
	>=sys-apps/hwloc-1.1.1-r1
	>=sys-process/numactl-2.0.6"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup slurm
	enewuser slurm -1 -1 /var/spool/slurm slurm
}

src_prepare() {
	# gentoo uses /sys/fs/cgroup instead of /dev/cgroup
	sed -e 's:/dev/cgroup:/sys/fs/cgroup:g' \
		-i "${S}/doc/man/man5/cgroup.conf.5" \
		-i "${S}/etc/cgroup.conf.example" \
		-i "${S}/etc/cgroup.release_agent" \
		-i "${S}/src/plugins/proctrack/cgroup/xcgroup.h" \
		|| die
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
	use pbs-compat && emake DESTDIR="${D}" -C contribs/torque install || die
	use static-libs || find "${ED}" -name '*.la' -exec rm {} +
	# we dont need it
	rm "${ED}/usr/bin/mpiexec" || die
	# install sample configs
	keepdir /etc/slurm
	keepdir /var/log/slurm
	keepdir /var/spool/slurm
	insinto /etc/slurm
	doins etc/cgroup.conf.example
	doins etc/federation.conf.example
	doins etc/slurm.conf.example
	doins etc/slurmdbd.conf.example
	exeinto /etc/slurm
	doexe etc/cgroup.release_agent
	doexe etc/slurm.epilog.clean
	# install init.d files
	newinitd "${FILESDIR}/slurmd.initd" slurmd
	newinitd "${FILESDIR}/slurmctld.initd" slurmctld
	newinitd "${FILESDIR}/slurmdbd.initd" slurmdbd
	# install conf.d files
	newconfd "${FILESDIR}/slurm.confd" slurmd
}

pkg_preinst() {
	if use munge; then
		sed -i 's,\(PBS_USE_MUNGE=\).*,\11,' "${D}"etc/conf.d/slurm || die
	fi
}

pkg_postinst() {
	elog "Please visit the file '/usr/share/doc/${P}/html/configurator.html"
	elog "through a (javascript enabled) browser to create a configureation file."
	elog "Copy that file to /etc/slurm.conf on all nodes (including the headnode) of your cluster."
}
