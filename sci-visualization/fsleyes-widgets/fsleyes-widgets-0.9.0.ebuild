# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1 virtualx

MY_P="widgets-${PV}"

DESCRIPTION="GUI widgets and utilities for the FSLeyes viewer"
HOMEPAGE="https://git.fmrib.ox.ac.uk/fsl/fsleyes/fsleyes/tree/master"
SRC_URI="https://git.fmrib.ox.ac.uk/fsl/fsleyes/widgets/-/archive/${PV}/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/deprecation[${PYTHON_USEDEP}]
	=dev-python/numpy-1*[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	=dev-python/six-1*[${PYTHON_USEDEP}]
	dev-python/wxpython[${PYTHON_USEDEP}]
	"

S="${WORKDIR}/${MY_P}"

distutils_enable_tests pytest

python_prepare_all() {
	# do not depend on pytest-cov
	sed -i -e '/addopts/d' setup.cfg || die

	# assert 0 == 1
	sed -i -e 's:test_FloatSlider_mouse_non_gtk:_&:' \
		-e 's:test_FloatSlider_mouse_gtk:_&:' \
		-e 's:test_SliderSpinPanel_events:_&:' \
		tests/test_floatslider.py || die

	# assert None == 0
	sed -i -e 's:test_notebook_events:_&:' \
		tests/test_notebook.py || die

	# assert 25.0 < 5
	sed -i -e 's:test_RangePanel_events_slider:_&:' \
		-e 's:test_RangeSliderSpinPanel_onchange:_&:' \
		tests/test_rangeslider.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	# If this could be set for the eclass, it might fix some of the tests:
	# https://github.com/pauldmccarthy/fsleyes-widgets/issues/1#issuecomment-575387724
	#xvfbargs="-screen 0 1920x1200x24 +extension RANDR"
	virtx pytest --verbose || die
}
