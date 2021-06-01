# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

MY_HASH="2bdacef4d1f4d760f6c8b5397db56928ea223563"

DESCRIPTION="Draw Gantt charts from Python"
HOMEPAGE="https://pypi.org/project/python-gantt/"
SRC_URI="https://github.com/stefanSchinkel/gantt/archive/${MY_HASH}.tar.gz -> ${P}.tar.gz"
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="test? ( >=dev-python/pytest-5.1.2[${PYTHON_USEDEP}] )"
RDEPEND="
	>=dev-python/matplotlib-3.0.3[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.16.3[${PYTHON_USEDEP}]
	"

S="${WORKDIR}/gantt-${MY_HASH}"

python_prepare() {
	sed -i\
		-e "s/matplotlib==3.0.3/matplotlib/g"\
		-e "s/numpy==1.16.3/numpy/g"\
		setup.py || die
	distutils-r1_python_prepare_all
}

distutils_enable_tests pytest
