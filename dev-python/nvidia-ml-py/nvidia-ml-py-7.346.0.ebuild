# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

DESCRIPTION="Python Bindings for the NVIDIA Management Library"
HOMEPAGE="https://developer.nvidia.com/ganglia-monitoring-system"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64"

LICENSE="BSD"
SLOT="0"

RDEPEND="=dev-util/nvidia-cuda-gdk-346.46[nvml]"
DEPEND="${RDEPEND}"
