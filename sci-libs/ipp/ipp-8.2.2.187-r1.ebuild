# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

INTEL_DPN=parallel_studio_xe
INTEL_DID=7538
INTEL_DPV=2015_update3
INTEL_SUBDIR=composerxe
INTEL_SINGLE_ARCH=false

inherit intel-sdp

DESCRIPTION="Intel Integrated Performance Primitive library"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-ipp/"

IUSE=""
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND=">=dev-libs/intel-common-15[${MULTILIB_USEDEP}]"
DEPEND=""

CHECKREQS_DISK_BUILD=6500M

INTEL_BIN_RPMS=( ipp-{ac,di,gen,jp,mt,mt-devel,mx,rr,sc,st,st-devel,vc} )
INTEL_DAT_RPMS=( ipp-common ipp-{ac,di,gen,jp,mx,rr,sc,st-devel,vc}-common )

INTEL_SKIP_LICENSE=true
