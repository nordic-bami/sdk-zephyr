# Copyright (c) 2023-2024 Nordic Semiconductor ASA
# SPDX-License-Identifier: Apache-2.0

if(SB_CONFIG_NET_CORE_IMAGE_HCI_IPC)
	set(NET_APP hci_ipc)
	set(NET_APP_SRC_DIR ${ZEPHYR_BASE}/samples/bluetooth/${NET_APP})

	ExternalZephyrProject_Add(
		APPLICATION ${NET_APP}
		SOURCE_DIR  ${NET_APP_SRC_DIR}
		BOARD       ${SB_CONFIG_NET_CORE_BOARD}
	)

	if(SB_CONFIG_SOC_NRF5340_CPUAPP)
		set(${NET_APP}_SNIPPET
		"bt-ll-sw-split"
		CACHE INTERNAL ""
		)
	endif()

	set(${NET_APP}_EXTRA_CONF_FILE
	 ${APP_DIR}/overlay-bt_ll_sw_split.conf
	 CACHE INTERNAL ""
	)

	native_simulator_set_child_images(${DEFAULT_IMAGE} ${NET_APP})
endif()

native_simulator_set_final_executable(${DEFAULT_IMAGE})
