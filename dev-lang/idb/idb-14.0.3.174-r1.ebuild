# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

INTEL_DPN=parallel_studio_xe
INTEL_DID=4220
INTEL_DPV=2013_sp1_update3
INTEL_SUBDIR=composerxe
INTEL_SINGLE_ARCH=false

inherit intel-sdp

DESCRIPTION="Intel C/C++/FORTRAN debugger"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-composer-xe/"

IUSE="eclipse"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND=">=dev-libs/intel-common-13.1[compiler,${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}
	virtual/jre"

INTEL_BIN_RPMS=( idb )
INTEL_DAT_RPMS=( idb-common idbcdt )

CHECKREQS_DISK_BUILD=475M

pkg_setup() {
	_INTEL_PV=174-13.0-3 intel-sdp_pkg_setup
}

src_prepare() {
	sed \
		-e "/^INSTALLDIR/s:=.*:=${INTEL_SDP_EDIR}:g" \
		-i ${INTEL_SDP_DIR}/bin/intel*/idb || die
}
