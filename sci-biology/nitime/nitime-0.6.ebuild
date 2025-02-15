# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Time-series analysis of neuroscience data"
HOMEPAGE="http://nipy.org/nitime/index.html"
SRC_URI="https://github.com/nipy/nitime/archive/rel/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

COMMON_DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	"
DEPEND="
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]
	"
RDEPEND="
	${COMMON_DEPEND}
	dev-python/networkx[${PYTHON_USEDEP}]
	sci-libs/nibabel[${PYTHON_USEDEP}]
	"

S="${WORKDIR}/${PN}-rel-${PV}"

python_test() {
	nosetests -v || die
}
