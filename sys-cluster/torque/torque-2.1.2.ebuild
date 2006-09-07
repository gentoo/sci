# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


inherit autotools flag-o-matic eutils

MY_P="${P/_}"
DESCRIPTION="Resource manager and queuing system based on OpenPBS"
HOMEPAGE="http://www.clusterresources.com/products/torque/"
SRC_URI="http://www.clusterresources.com/downloads/${PN}/${MY_P}.tar.gz"

LICENSE="openpbs"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tk scp server"
PROVIDE="virtual/pbs"

# ed is used by makedepend-sh
DEPEND_COMMON="virtual/libc
	sys-libs/ncurses
	sys-libs/readline
	tk? ( dev-tcltk/tclx )
	!virtual/pbs"

DEPEND="${DEPEND_COMMON}
	sys-apps/ed"

RDEPEND="${DEPEND_COMMON}
	scp? net-misc/openssh
	!scp? ( net-misc/netkit-rsh )"

PDEPEND=">=sys-cluster/openpbs-common-1.1.1"

S="${WORKDIR}/${MY_P}"

SPOOL_LOCATION="/var/spool" # this needs to move to /var later on
PBS_SERVER_HOME="${SPOOL_LOCATION}/PBS/"


src_unpack() {
	unpack "${A}"
	cd "${S}"
	epatch ${FILESDIR}/${PN}-setuid-safety.patch
}



src_compile() {

	local myconf
	if use server; then
		myconf="--enable-server  --with-default-server=$(hostname)"
	elif [ -z "${PBS_SERVER_NAME}" ]; then
		myconf="--disable-server --with-default-server=${PBS_SERVER_NAME}"
	else
		myconf="--disable-server --with-default-server=$(hostname)"
	fi

	if use scp; then
		myconf="${myconf} --with-rcp=scp"
	else
		myconf="${myconf} --with-rcp=mom_rcp"
	fi

	econf \
		$(use_enable tk gui) \
		--libdir="\${exec_prefix}/$(get_libdir)/pbs" \
		--with-server-home=${PBS_SERVER_HOME} \
		--with-environ=/etc/pbs_environment \
		${myconf} \
		|| die "econf failed"

	emake || die "emake failed"
}

# WARNING
# OpenPBS is extremely stubborn about directory permissions. Sometimes it will
# just fall over with the error message, but in some spots it will just ignore
# you and fail strangely. Likewise it also barfs on our .keep files!
pbs_createspool() {
	root="$1"
	s="${SPOOL_LOCATION}"
	h="${PBS_SERVER_HOME}"
	sp="${h}/server_priv"
	einfo "Building spool directory under ${D}${h}"
	for a in \
			0755:${s} 0755:${h} 0755:${h}/aux 0700:${h}/checkpoint \
			0755:${h}/mom_logs 0751:${h}/mom_priv 0751:${h}/mom_priv/jobs \
			0755:${h}/sched_logs 0750:${h}/sched_priv \
			0755:${h}/server_logs \
			0750:${h}/server_priv 0755:${h}/server_priv/accounting \
			0750:${h}/server_priv/acl_groups 0750:${h}/server_priv/acl_hosts \
			0750:${h}/server_priv/acl_svr 0750:${h}/server_priv/acl_users \
			0750:${h}/server_priv/jobs 0750:${h}/server_priv/queues \
			1777:${h}/spool 1777:${h}/undelivered ;
	do
		d="${a/*:}"
		m="${a/:*}"
		if [ ! -d "${root}${d}" ]; then
			install -d -m${m} ${root}${d}
		else
			chmod ${m} ${root}${d}
		fi
	done
}

src_install() {
	# Make directories first
	pbs_createspool "${D}"

	make DESTDIR=${D} install || die "make install failed"
	dodoc CHANGELOG DEVELOPMENT README.* Release_Notes doc/admin_guide.ps

	# this file MUST exist for PBS/Torque to work
	# but try to preserve any customatizations that the user has made
	dodir /etc
	if [ -f ${ROOT}/etc/pbs_environment ]; then
		cp ${ROOT}/etc/pbs_environment ${D}/etc/pbs_environment
	else
		touch ${D}/etc/pbs_environment
	fi

	if [ -f "${ROOT}/var/spool/PBS/server_name" ]; then
		cp "${ROOT}/var/spool/PBS/server_name" "${D}/var/spool/PBS/server_name"
	fi

	# The build script isn't alternative install location friendly,
	# So we have to fix some hard-coded paths in tclIndex for xpbs* to work
	for file in `find ${D} -iname tclIndex`; do
		sed -e "s/${D//\// }/ /" "${file}" > "${file}.new"
		mv "${file}.new" "${file}"
	done
}

pkg_postinst() {
	# make sure the damn directories exist
	pbs_createspool "${ROOT}"
	[ ! -f "${ROOT}/etc/pbs_environment" ] && \
		touch "${ROOT}/etc/pbs_environment"
}
