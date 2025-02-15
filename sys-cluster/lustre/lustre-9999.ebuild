# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

WANT_AUTOCONF="2.5"
WANT_AUTOMAKE="1.15"
WANT_LIBTOOL="latest"

if [[ $PV = *9999* ]]; then
	KEYWORDS=""
	EGIT_BRANCH="master"
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="${PV}"
fi

SUPPORTED_KV_MAJOR=4
SUPPORTED_KV_MINOR=1

inherit git-r3 autotools linux-info linux-mod toolchain-funcs udev flag-o-matic

DESCRIPTION="Lustre is a parallel distributed file system"
HOMEPAGE="http://wiki.whamcloud.com/"
SRC_URI=""
EGIT_REPO_URI="git://git.whamcloud.com/fs/lustre-release.git"

LICENSE="GPL-2"
SLOT="0"
IUSE="+client +utils +modules +dlc server readline tests"

RDEPEND="
	virtual/awk
	dlc? ( dev-libs/libyaml )
	readline? ( sys-libs/readline:0 )
	server? (
		>=sys-kernel/spl-0.6.1
		>=sys-fs/zfs-kmod-0.6.1
		sys-fs/zfs
	)
	"
DEPEND="${RDEPEND}
	dev-python/docutils
	virtual/linux-sources"

REQUIRED_USE="
	client? ( modules )
	server? ( modules )"

pkg_pretend() {
	KVSUPP=${SUPPORTED_KV_MAJOR}.${SUPPORTED_KV_MINOR}.x
	if kernel_is gt ${SUPPORTED_KV_MAJOR} ${SUPPORTED_KV_MINOR}; then
		eerror "Unsupported kernel version! Latest supported one is ${KVSUPP}"
		die
	fi
}

pkg_setup() {
	filter-mfpmath sse
	filter-mfpmath i386
	filter-flags -msse* -mavx* -mmmx -m3dnow
	linux-mod_pkg_setup
	ARCH="$(tc-arch-kernel)"
	ABI="${KERNEL_ABI}"
}

src_prepare() {
	if [ ${#PATCHES[0]} -ne 0 ]; then
		epatch ${PATCHES[@]}
	fi
	eapply_user
	# replace upstream autogen.sh by our src_prepare()
	local DIRS="libcfs lnet lustre snmp"
	local ACLOCAL_FLAGS
	for dir in $DIRS ; do
		ACLOCAL_FLAGS="$ACLOCAL_FLAGS -I $dir/autoconf"
	done
	_elibtoolize -q
	eaclocal -I config $ACLOCAL_FLAGS
	eautoheader
	eautomake
	eautoconf
}

src_configure() {
	local myconf
	if use server; then
		SPL_PATH=$(basename $(echo "${EROOT}usr/src/spl-"*)) \
			myconf="${myconf} --with-spl=${EROOT}usr/src/${SPL_PATH} \
							--with-spl-obj=${EROOT}usr/src/${SPL_PATH}/${KV_FULL}"
		ZFS_PATH=$(basename $(echo "${EROOT}usr/src/zfs-"*)) \
			myconf="${myconf} --with-zfs=${EROOT}usr/src/${ZFS_PATH} \
							--with-zfs-obj=${EROOT}usr/src/${ZFS_PATH}/${KV_FULL}"
	fi
	econf \
		${myconf} \
		--without-ldiskfs \
		--with-linux="${KERNEL_DIR}" \
		$(use_enable dlc) \
		$(use_enable client) \
		$(use_enable utils) \
		$(use_enable modules) \
		$(use_enable server) \
		$(use_enable readline) \
		$(use_enable tests)
}

src_compile() {
	default
}

src_install() {
	default
	newinitd "${FILESDIR}/lnet.initd" lnet
	newinitd "${FILESDIR}/lustre-client.initd" lustre-client
}
