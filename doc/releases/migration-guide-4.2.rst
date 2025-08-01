:orphan:

..
  See
  https://docs.zephyrproject.org/latest/releases/index.html#migration-guides
  for details of what is supposed to go into this document.

.. _migration_4.2:

Migration guide to Zephyr v4.2.0 (Working Draft)
################################################

This document describes the changes required when migrating your application from Zephyr v4.1.0 to
Zephyr v4.2.0.

Any other changes (not directly related to migrating applications) can be found in
the :ref:`release notes<zephyr_4.2>`.

.. contents::
    :local:
    :depth: 2

Build System
************

Kernel
******

Boards
******

* All boards based on Nordic ICs that used the ``nrfjprog`` Nordic command-line
  tool for flashing by default have been modified to instead default to the new
  nRF Util (``nrfutil``) tool. This means that you may need to `install nRF Util
  <https://www.nordicsemi.com/Products/Development-tools/nrf-util>`_ or, if you
  prefer to continue using ``nrfjprog``, you can do so by invoking west while
  specfying the runner: ``west flash -r nrfjprog``. The full documentation for
  nRF Util can be found
  `here <https://docs.nordicsemi.com/bundle/nrfutil/page/README.html>`_.

* All boards based on a Nordic IC of the nRF54L series now default to not
  erasing any part of the internal storage when flashing. If you'd like to
  revert to the previous default of erasing the pages that will be written to by
  the firmware to be flashed you can set the new ``--erase-mode`` command-line
  switch when invoking ``west flash`` to ``ranges``.
  Note that RRAM on nRF54L devices is not physically paged, and paging is
  only artificially provided, with a page size of 4096 bytes, for an easier
  transition of nRF52 software to nRF54L devices.

* The config option :kconfig:option:`CONFIG_NATIVE_POSIX_SLOWDOWN_TO_REAL_TIME` has been deprecated
  in favor of :kconfig:option:`CONFIG_NATIVE_SIM_SLOWDOWN_TO_REAL_TIME`.

* The DT binding :dtcompatible:`zephyr,native-posix-cpu` has been deprecated in favor of
  :dtcompatible:`zephyr,native-sim-cpu`.

* Zephyr now supports version 1.11.3 of the :zephyr:board:`neorv32`. NEORV32 processor (SoC)
  implementations need to be updated to this version to be compatible with Zephyr v4.2.0.

* The :zephyr:board:`neorv32` now targets NEORV32 processor (SoC) templates via board variants. The
  old ``neorv32`` board target is now named ``neorv32/neorv32/up5kdemo``.

* ``arduino_uno_r4_minima``, ``arduino_uno_r4_wifi``, and ``mikroe_clicker_ra4m1`` have migrated to
  new FSP-based configurations.
  While there are no major functional changes, the device tree structure has been significantly revised.
  The following device tree bindings are now removed:
  ``renesas,ra-gpio``, ``renesas,ra-uart-sci``, ``renesas,ra-pinctrl``,
  ``renesas,ra-clock-generation-circuit``, and ``renesas,ra-interrupt-controller-unit``.
  Instead, use the following replacements:
  - :dtcompatible:`renesas,ra-gpio-ioport`
  - :dtcompatible:`renesas,ra-sci-uart`
  - :dtcompatible:`renesas,ra-pinctrl-pfs`
  - :dtcompatible:`renesas,ra-cgc-pclk-block`

* Nucleo WBA52CG board (``nucleo_wba52cg``) is not supported anymore since it is NRND
  (Not Recommended for New Design) and it is not supported anymore in the STM32CubeWBA from
  version 1.1.0 (July 2023). The migration to :zephyr:board:`nucleo_wba55cg` (``nucleo_wba55cg``)
  is recommended and it could be done without any change.

* Espressif boards ``esp32_devkitc_wroom`` and ``esp32_devkitc_wrover`` shared almost identical features.
  The differences are covered by the Kconfig options so both boards were merged into ``esp32_devkitc``.

* STM32 boards should now add OpenOCD programming support by including ``openocd-stm32.board.cmake``
  instead of ``openocd.board.cmake``. The ``openocd-stm32.board.cmake`` file extends the default
  OpenOCD runner with manufacturer-specific configuration like STM32 mass erase commands.

Device Drivers and Devicetree
*****************************

Devicetree
==========

* Many of the vendor-specific and arch-specific files that were in dts/common have been moved
  to more specific locations. Therefore, any dts files which ``#include <common/some_file.dtsi>``
  a file from in the zephyr tree will need to be changed to just ``#include <some_file.dtsi>``.

* Silicon Labs SoC-level dts files for Series 2 have been reorganized in subdirectories per device
  superfamily. Therefore, any dts files for boards that use Series 2 SoCs will need to change their
  include from ``#include <silabs/some_soc.dtsi>`` to ``#include <silabs/xg2[1-9]/some_soc.dtsi>``.

DAI
===

* Renamed the devicetree property ``dai_id`` to ``dai-id``.
* Renamed the devicetree property ``afe_name`` to ``afe-name``.
* Renamed the devicetree property ``agent_disable`` to ``agent-disable``.
* Renamed the devicetree property ``ch_num`` to ``ch-num``.
* Renamed the devicetree property ``mono_invert`` to ``mono-invert``.
* Renamed the devicetree property ``quad_ch`` to ``quad-ch``.
* Renamed the devicetree property ``int_odd`` to ``int-odd``.

DMA
===

* Renamed the devicetree property ``nxp,a_on`` to ``nxp,a-on``.
* Renamed the devicetree property ``dma_channels`` to ``dma-channels``.
* The binding files for Xilinx DMA controllers have been renamed to use the proper vendor prefix
  (``xlnx`` instead of ``xilinx``) and to match their compatible string.

Regulator
=========

* :dtcompatible:`nordic,npm1300-regulator` BUCK and LDO node GPIO properties are now specified as an
  integer array without a GPIO controller, removing the requirement for a
  :dtcompatible:`nordic,npm1300-gpio` node to be present and enabled for GPIO control of the output
  rails. For example, ``enable-gpios = <&pmic_gpios 3 GPIO_ACTIVE_LOW>;`` is now specified as
  ``enable-gpio-config = <3 GPIO_ACTIVE_LOW>;``.

Counter
=======

* ``counter_native_posix`` has been renamed ``counter_native_sim``, and with it its
  kconfig options and DT binding. :dtcompatible:`zephyr,native-posix-counter`  has been deprecated
  in favor of :dtcompatible:`zephyr,native-sim-counter`.
  And :kconfig:option:`CONFIG_COUNTER_NATIVE_POSIX` and its related options with
  :kconfig:option:`CONFIG_COUNTER_NATIVE_SIM` (:github:`86616`).

Entropy
=======

* ``fake_entropy_native_posix`` has been renamed ``fake_entropy_native_sim``, and with it its
  kconfig options and DT binding. :dtcompatible:`zephyr,native-posix-rng`  has been deprecated
  in favor of :dtcompatible:`zephyr,native-sim-rng`.
  And :kconfig:option:`CONFIG_FAKE_ENTROPY_NATIVE_POSIX` and its related options with
  :kconfig:option:`CONFIG_FAKE_ENTROPY_NATIVE_SIM` (:github:`86615`).

Eeprom
========

* :dtcompatible:`ti,tmp116-eeprom` has been renamed to :dtcompatible:`ti,tmp11x-eeprom` because it
  supports both tmp117 and tmp119.

Ethernet
========

* Removed Kconfig option ``ETH_STM32_HAL_MII`` (:github:`86074`).
  PHY interface type is now selected via the ``phy-connection-type`` property in the device tree.

* The :dtcompatible:`st,stm32-ethernet` driver now requires the ``phy-handle`` phandle to be
  set to the according PHY node in the device tree (:github:`87593`).

* The Kconfig options ``ETH_STM32_HAL_PHY_ADDRESS``, ``ETH_STM32_CARRIER_CHECK``,
  ``ETH_STM32_CARRIER_CHECK_RX_IDLE_TIMEOUT_MS``, ``ETH_STM32_AUTO_NEGOTIATION_ENABLE``,
  ``ETH_STM32_SPEED_10M``, ``ETH_STM32_MODE_HALFDUPLEX`` have been removed, as they are no longer
  needed, and the driver now uses the ethernet phy api to communicate with the phy driver, which
  is resposible for configuring the phy settings (:github:`87593`).

* ``ethernet_native_posix`` has been renamed ``ethernet_native_tap``, and with it its
  kconfig options: :kconfig:option:`CONFIG_ETH_NATIVE_POSIX` and its related options have been
  deprecated in favor of :kconfig:option:`CONFIG_ETH_NATIVE_TAP` (:github:`86578`).

* NuMaker Ethernet driver ``eth_numaker.c`` now supports ``gen_random_mac``,
  and the EMAC data flash feature has been removed (:github:`87953`).

* The enum ``ETHERNET_DSA_MASTER_PORT`` and ``ETHERNET_DSA_SLAVE_PORT`` in
  :zephyr_file:`include/zephyr/net/ethernet.h` have been renamed
  to ``ETHERNET_DSA_CONDUIT_PORT`` and ``ETHERNET_DSA_USER_PORT``.

* Enums for the Ethernet speed have been renamed to be more indepedent of the used medium.
  ``LINK_HALF_10BASE_T``, ``LINK_FULL_10BASE_T``, ``LINK_HALF_100BASE_T``, ``LINK_FULL_100BASE_T``,
  ``LINK_HALF_1000BASE_T``, ``LINK_FULL_1000BASE_T``, ``LINK_FULL_2500BASE_T`` and
  ``LINK_FULL_5000BASE_T`` have been renamed to :c:enumerator:`LINK_HALF_10BASE`,
  :c:enumerator:`LINK_FULL_10BASE`, :c:enumerator:`LINK_HALF_100BASE`,
  :c:enumerator:`LINK_FULL_100BASE`, :c:enumerator:`LINK_HALF_1000BASE`,
  :c:enumerator:`LINK_FULL_1000BASE`, :c:enumerator:`LINK_FULL_2500BASE` and
  :c:enumerator:`LINK_FULL_5000BASE`.
  ``ETHERNET_LINK_10BASE_T``, ``ETHERNET_LINK_100BASE_T``, ``ETHERNET_LINK_1000BASE_T``,
  ``ETHERNET_LINK_2500BASE_T`` and ``ETHERNET_LINK_5000BASE_T`` have been renamed to
  :c:enumerator:`ETHERNET_LINK_10BASE`, :c:enumerator:`ETHERNET_LINK_100BASE`,
  :c:enumerator:`ETHERNET_LINK_1000BASE`, :c:enumerator:`ETHERNET_LINK_2500BASE` and
  :c:enumerator:`ETHERNET_LINK_5000BASE` respectively (:github:`87194`).

Enhanced Serial Peripheral Interface (eSPI)
===========================================

* Renamed the devicetree property ``io_girq`` to ``io-girq``.
* Renamed the devicetree property ``vw_girqs`` to ``vw-girqs``.
* Renamed the devicetree property ``pc_girq`` to ``pc-girq``.
* Renamed the devicetree property ``poll_timeout`` to ``poll-timeout``.
* Renamed the devicetree property ``poll_interval`` to ``poll-interval``.
* Renamed the devicetree property ``consec_rd_timeout`` to ``consec-rd-timeout``.
* Renamed the devicetree property ``sus_chk_delay`` to ``sus-chk-delay``.
* Renamed the devicetree property ``sus_rsm_interval`` to ``sus-rsm-interval``.

GPIO
====

* To support the RP2350B, which has many pins, the Raspberry Pi-GPIO configuration has
  been changed. The previous role of :dtcompatible:`raspberrypi,rpi-gpio` has been migrated to
  :dtcompatible:`raspberrypi,rpi-gpio-port`, and :dtcompatible:`raspberrypi,rpi-gpio` is
  now left as a placeholder and mapper.
  The labels have also been changed along, so no changes are necessary for regular use.
* ``arduino-nano-header-r3`` is renamed to :dtcompatible:`arduino-nano-header`.
  Because the R3 comes from the Arduino UNO R3, which has changed the connector from
  the former version, and is unrelated to the Arduino Nano.
* Moved file ``include/zephyr/dt-bindings/gpio/nordic-npm1300-gpio.h`` to
  :zephyr_file:`include/zephyr/dt-bindings/gpio/nordic-npm13xx-gpio.h` and renamed all instances of
  ``NPM1300`` to ``NPM13XX`` in the defines
* Renamed ``CONFIG_GPIO_NPM1300`` to :kconfig:option:`CONFIG_GPIO_NPM13XX`,
  ``CONFIG_GPIO_NPM1300_INIT_PRIORITY`` to :kconfig:option:`CONFIG_GPIO_NPM13XX_INIT_PRIORITY`

I2S
===
* The :dtcompatible:`nxp,mcux-i2s` driver added property ``mclk-output``. Set this property to
* configure the MCLK signal as an output.  Older driver versions used the macro
* ``I2S_OPT_BIT_CLK_SLAVE`` to configure the MCLK signal direction. (:github:`88554`)

LED
===

* Renamed ``CONFIG_LED_NPM1300`` to :kconfig:option:`CONFIG_LED_NPM13XX`

MFD
===

* Moved file ``include/zephyr/drivers/mfd/npm1300.h`` to :zephyr_file:`include/zephyr/drivers/mfd/npm13xx.h`
  and renamed all instances of ``npm1300``/``NPM1300`` to ``npm13xx``/``NPM13XX`` in the enums and
  function names
* Renamed ``CONFIG_MFD_NPM1300`` to :kconfig:option:`CONFIG_MFD_NPM13XX`,
  ``CONFIG_MFD_NPM1300_INIT_PRIORITY`` to :kconfig:option:`CONFIG_MFD_NPM13XX_INIT_PRIORITY`

Regulator
=========

* Moved file ``include/zephyr/dt-bindings/regulator/npm1300.h`` to
  :zephyr_file:`include/zephyr/dt-bindings/regulator/npm13xx.h` and renamed all instances of
  ``NPM1300`` to ``NPM13XX`` in the defines
* Renamed ``CONFIG_REGULATOR_NPM1300`` to :kconfig:option:`CONFIG_REGULATOR_NPM13XX`,
  ``CONFIG_REGULATOR_NPM1300_COMMON_INIT_PRIORITY`` to :kconfig:option:`REGULATOR_NPM13XX_COMMON_INIT_PRIORITY`,
  ``CONFIG_REGULATOR_NPM1300_INIT_PRIORITY`` to :kconfig:option:`CONFIG_REGULATOR_NPM13XX_INIT_PRIORITY`

Sensors
=======

* ``ltr`` vendor prefix has been renamed to ``liteon``, and with it the
  :dtcompatible:`ltr,f216a` name has been replaced by :dtcompatible:`liteon,ltrf216a`.
  The choice :kconfig:option:`DT_HAS_LTR_F216A_ENABLED` has been replaced with
  :kconfig:option:`DT_HAS_LITEON_LTRF216A_ENABLED` (:github:`85453`)

* :dtcompatible:`ti,tmp116` has been renamed to :dtcompatible:`ti,tmp11x` because it supports
  tmp116, tmp117 and tmp119.

* :dtcompatible:`meas,ms5837` has been replaced by :dtcompatible:`meas,ms5837-30ba`
  and :dtcompatible:`meas,ms5837-02ba`. In order to use one of the two variants, the
  status property needs to be used as well.

* The :dtcompatible:`we,wsen-itds` driver has been renamed to
  :dtcompatible:`we,wsen-itds-2533020201601`.
  The Device Tree can be configured as follows:

  .. code-block:: devicetree

    &i2c0 {
      itds:itds-2533020201601@19 {
        compatible = "we,wsen-itds-2533020201601";
        reg = <0x19>;
        odr = "400";
        op-mode = "high-perf";
        power-mode = "normal";
        events-interrupt-gpios = <&gpio1 1 GPIO_ACTIVE_HIGH>;
        drdy-interrupt-gpios = < &gpio1 2 GPIO_ACTIVE_HIGH >;
      };
    };

* The binding file for :dtcompatible:`raspberrypi,pico-temp.yaml` has been renamed to have a name
  matching the compatible string.

* Moved file ``include/zephyr/drivers/sensor/npm1300_charger.h`` to
  :zephyr_file:`include/zephyr/drivers/sensor/npm13xx_charger.h` and renamed all instances of
  ``NPM1300`` to ``NPM13XX`` in the enums

* Renamed ``CONFIG_NPM1300_CHARGER`` to :kconfig:option:`CONFIG_NPM13XX_CHARGER`

Serial
=======

* ``uart_native_posix`` has been renamed ``uart_native_pty``, and with it its
  kconfig options and DT binding. :dtcompatible:`zephyr,native-posix-uart`  has been deprecated
  in favor of :dtcompatible:`zephyr,native-pty-uart`.
  :kconfig:option:`CONFIG_UART_NATIVE_POSIX` and its related options with
  :kconfig:option:`CONFIG_UART_NATIVE_PTY`.
  The choice :kconfig:option:`CONFIG_NATIVE_UART_0` has been replaced with
  :kconfig:option:`CONFIG_UART_NATIVE_PTY_0`, but now, it is also possible to select if a UART is
  connected to the process stdin/out instead of a PTY at runtime with the command line option
  ``--<uart_name>_stdinout``.
  :kconfig:option:`CONFIG_NATIVE_UART_AUTOATTACH_DEFAULT_CMD` has been replaced with
  :kconfig:option:`CONFIG_UART_NATIVE_PTY_AUTOATTACH_DEFAULT_CMD`.
  :kconfig:option:`CONFIG_UART_NATIVE_WAIT_PTS_READY_ENABLE` has been deprecated. The functionality
  it enabled is now always enabled as there is no drawbacks from it.
  :kconfig:option:`CONFIG_UART_NATIVE_POSIX_PORT_1_ENABLE` has been deprecated. This option does
  nothing now. Instead users should instantiate as many :dtcompatible:`zephyr,native-pty-uart` nodes
  as native PTY UART instances they want. (:github:`86739`)

Timer
=====

* ``native_posix_timer`` has been renamed ``native_sim_timer``, and so its kconfig option
  :kconfig:option:`CONFIG_NATIVE_POSIX_TIMER` has been deprecated in favor of
  :kconfig:option:`CONFIG_NATIVE_SIM_TIMER`, (:github:`86612`).

* :dtcompatible:`andestech,machine-timer`, :dtcompatible:`neorv32-machine-timer`,
  :dtcompatible:`telink,machine-timer`, :dtcompatible:`lowrisc,machine-timer`,
  :dtcompatible:`niosv-machine-timer`, and :dtcompatible:`scr,machine-timer` have
  been unified under :dtcompatible:`riscv,machine-timer`.

  The addresses of both ``MTIME`` and ``MTIMECMP`` registers must now be explicitly
  specified using the ``reg`` and ``reg-names`` properties. The ``reg-names`` property
  is now **required**, and must list names corresponding one-to-one with each entry
  in ``reg``. (:github:`84175` and :github:`89847`)

  Example:

  .. code-block:: devicetree

    mtimer: timer@d1000000 {
        compatible = "riscv,machine-timer";
        interrupts-extended = <&cpu0_intc 7>;
        reg = <0xd1000000 0x8
               0xd1000008 0x8>;
        reg-names = "mtime", "mtimecmp";
    };

Watchdog
========
* Renamed ``CONFIG_WDT_NPM1300`` to :kconfig:option:`CONFIG_WDT_NPM13XX`,
  ``CONFIG_WDT_NPM1300_INIT_PRIORITY`` to :kconfig:option:`CONFIG_WDT_NPM13XX_INIT_PRIORITY`

Modem
=====

* Removed Kconfig option :kconfig:option:`CONFIG_MODEM_CELLULAR_CMUX_MAX_FRAME_SIZE` in favor of
  :kconfig:option:`CONFIG_MODEM_CMUX_WORK_BUFFER_SIZE` and :kconfig:option:`CONFIG_MODEM_CMUX_MTU`.

Flash
=====

* Renamed the file from ``flash_hp_ra.h`` to ``soc_flash_renesas_ra_hp.h``.
* Renamed the file from ``flash_hp_ra.c`` to ``soc_flash_renesas_ra_hp.c``.
* Renamed the file from ``flash_hp_ra_ex_op.c`` to ``soc_flash_renesas_ra_hp_ex_op.c``.

* The Flash HP Renesas RA dual bank mode Kconfig symbol :kconfig:option:`CONFIG_DUAL_BANK_MODE`
  has been removed.
* The Flash HP Renesas RA Kconfig symbol :kconfig:option:`CONFIG_RA_FLASH_HP`
  has been renamed to :kconfig:option:`CONFIG_SOC_FLASH_RENESAS_RA_HP`.
* The Flash HP Renesas RA write protect Kconfig symbol :kconfig:option:`CONFIG_FLASH_RA_WRITE_PROTECT`
  has been renamed to :kconfig:option:`CONFIG_FLASH_RENESAS_RA_HP_WRITE_PROTECT`.

* Separate the file ``renesas,ra-nv-flash.yaml`` into 2 files ``renesas,ra-nv-code-flash.yaml``
  and ``renesas,ra-nv-data-flash.yaml``.
* Separate the ``compatible`` from ``renesas,ra-nv-flash`` to :dtcompatible:`renesas,ra-nv-code-flash.yaml`
  and :dtcompatible:`renesas,ra-nv-data-flash.yaml`.


Stepper
=======

* Refactored the ``stepper_enable(const struct device * dev, bool enable)`` function to
  :c:func:`stepper_enable` & :c:func:`stepper_disable`.

Misc
====

* Moved file ``drivers/memc/memc_nxp_flexram.h`` to
  :zephyr_file:`include/zephyr/drivers/misc/flexram/nxp_flexram.h` so that the
  file can be included using ``<zephyr/drivers/misc/flexram/nxp_flexram.h>``.
  Modification to CMakeList.txt to use include this driver is no longer
  required.
* All memc_flexram_* namespaced things including kconfigs and C API
  have been changed to just flexram_*.

Bluetooth
*********

Bluetooth Audio
===============

* ``CONFIG_BT_CSIP_SET_MEMBER_NOTIFIABLE`` has been renamed to
  :kconfig:option:`CONFIG_BT_CSIP_SET_MEMBER_SIRK_NOTIFIABLE``. (:github:`86763``)

* ``bt_csip_set_member_get_sirk`` has been removed. Use :c:func:`bt_csip_set_member_get_info` to get
  the SIRK (and other information). (:github:`86996`)

* ``BT_AUDIO_CONTEXT_TYPE_PROHIBITED`` has been renamed to
  :c:enumerator:`BT_AUDIO_CONTEXT_TYPE_NONE`. (:github:`89506`)

Bluetooth HCI
=============

* The buffer types passing through the HCI driver interface are now indicated as H:4 encoded prefix
  bytes as part of the buffer payload itself. The bt_buf_set_type() and bt_buf_get_type() functions
  have been deprecated, but are still usable, with the exception that they can only be
  called once per buffer.

* The :c:func:`bt_hci_cmd_create` function has been depracated and the new :c:func:`bt_hci_cmd_alloc`
  function should be used instead. The new function takes no parameters because the command
  sending functions have been updated to do the command header encoding.

Bluetooth Host
==============

* The symbols ``BT_LE_CS_TONE_ANTENNA_CONFIGURATION_INDEX_<NUMBER>`` in
  :zephyr_file:`include/zephyr/bluetooth/conn.h` have been renamed
  to ``BT_LE_CS_TONE_ANTENNA_CONFIGURATION_A<NUMBER>_B<NUMBER>``.

* The ISO data paths are not longer setup automatically, and shall explicitly be setup and removed
  by the application by calling :c:func:`bt_iso_setup_data_path` and
  :c:func:`bt_iso_remove_data_path` respectively. (:github:`75549`)

* ``BT_ISO_CHAN_TYPE_CONNECTED`` has been split into ``BT_ISO_CHAN_TYPE_CENTRAL`` and
  ``BT_ISO_CHAN_TYPE_PERIPHERAL`` to better describe the type of the ISO channel, as behavior for
  each role may be different. Any existing uses/checks for ``BT_ISO_CHAN_TYPE_CONNECTED``
  can be replaced with an ``||`` of the two. (:github:`75549`)

* The ``struct _bt_gatt_ccc`` in :zephyr_file:`include/zephyr/bluetooth/gatt.h` has been renamed to
  struct :c:struct:`bt_gatt_ccc_managed_user_data`. (:github:`88652`)

* The macro ``BT_GATT_CCC_INITIALIZER`` in :zephyr_file:`include/zephyr/bluetooth/gatt.h`
  has been renamed to :c:macro:`BT_GATT_CCC_MANAGED_USER_DATA_INIT`. (:github:`88652`)

* The ``CONFIG_BT_ISO_TX_FRAG_COUNT`` Kconfig option was removed as it was completely unused.
  Any uses of it can simply be removed. (:github:`89836`)

Bluetooth Classic
=================

* The parameters of HFP AG callback ``sco_disconnected`` of the struct :c:struct:`bt_hfp_ag_cb`
  have been changed to SCO connection object ``struct bt_conn *sco_conn`` and the disconnection
  reason of the SCO connection ``uint8_t reason``.

Networking
**********

* The struct ``net_linkaddr_storage`` has been renamed to struct
  :c:struct:`net_linkaddr` and the old struct ``net_linkaddr`` has been removed.
  The struct :c:struct:`net_linkaddr` now contains space to store the link
  address instead of having pointer that point to the link address. This avoids
  possible dangling pointers when cloning struct :c:struct:`net_pkt`. This will
  increase the size of struct :c:struct:`net_pkt` by 4 octets for IEEE 802.15.4,
  but there is no size increase for other network technologies like Ethernet.
  Note that any code that is using struct :c:struct:`net_linkaddr` directly, and
  which has checks like ``if (lladdr->addr == NULL)``, will no longer work as expected
  (because the addr is not a pointer) and must be changed to ``if (lladdr->len == 0)``
  if the code wants to check that the link address is not set.

* TLS credential type ``TLS_CREDENTIAL_SERVER_CERTIFICATE`` was renamed to
  more generic :c:enumerator:`TLS_CREDENTIAL_PUBLIC_CERTIFICATE` to better
  reflect the purpose of this credential type.

* The MQTT public API function :c:func:`mqtt_disconnect` has changed. The function
  now accepts additional ``param`` parameter to support MQTT 5.0 case. The parameter
  is optional and not used with older MQTT versions - MQTT 3.1.1 users should pass
  NULL as an argument.

* The ``AF_PACKET/SOCK_RAW/IPPROTO_RAW`` socket combination is no longer supported,
  as ``AF_PACKET`` sockets should only accept IEEE 802.3 protocol numbers. As an
  alternative, ``AF_PACKET/SOCK_DGRAM/ETH_P_ALL`` or ``AF_INET(6)/SOCK_RAW/IPPROTO_IP``
  sockets can be used, depending on the actual use case.

* The HTTP server now respects the configured ``_concurrent`` and  ``_backlog`` values. Check that
  you provide applicable values to :c:macro:`HTTP_SERVICE_DEFINE_EMPTY`,
  :c:macro:`HTTPS_SERVICE_DEFINE_EMPTY`, :c:macro:`HTTP_SERVICE_DEFINE` and
  :c:macro:`HTTPS_SERVICE_DEFINE`.

* :kconfig:option:`CONFIG_NET_ZPERF` no longer includes server support by default. To use
  the server commands, enable :kconfig:option:`CONFIG_NET_ZPERF_SERVER`. If server support
  is not needed, :kconfig:option:`CONFIG_ZVFS_POLL_MAX` can possibly be reduced.

* The L2 Wi-Fi shell now supports interface option for most commands, to accommodate this
  change some of the existing options have been renamed. The following table
  summarizes the changes:

  +------------------------+---------------------+--------------------+
  | Command(s)             | Old option          | New option         |
  +------------------------+---------------------+--------------------+
  | ``wifi connect``       | ``-i``              | ``-g``             |
  | ``wifi ap enable``     |                     |                    |
  +------------------------+---------------------+--------------------+
  | ``wifi twt setup``     | ``-i``              | ``-p``             |
  +------------------------+---------------------+--------------------+
  | ``wifi ap config``     | ``-i``              | ``-t``             |
  +------------------------+---------------------+--------------------+
  | ``wifi mode``          | ``--if-index``      | ``--iface``        |
  | ``wifi channel``       |                     |                    |
  | ``wifi packet_filter`` |                     |                    |
  +------------------------+---------------------+--------------------+

* The :c:type:`http_response_cb_t` HTTP client response callback signature has
  changed. The callback function now returns ``int`` instead of ``void``. This
  allows the application to abort the HTTP connection. Existing applications
  need to update their response callback implementations. To retain current
  behavior, simply return 0 from the callback.

OpenThread
==========

* The OpenThread stack integration in Zephyr has undergone a major refactor.
  The implementation has been moved from the Zephyr networking layer (``subsys/net/l2/openthread/``)
  to a dedicated module (``modules/openthread/``).

* OpenThread is now a standalone module in Zephyr.
  It can be used independently of Zephyr's networking stack (L2 and IEEE802.15.4 shim layers).
  This enables new use cases, such as applications that use OpenThread directly with their
  own IEEE802.15.4 driver, or that do not need the full Zephyr networking stack.

* Most functions in the :zephyr_file:`include/zephyr/net/openthread.h` file have been deprecated.
  These deprecated APIs are still available for backward compatibility, but new applications should
  use the new APIs provided by the OpenThread module. The following list summarizes the changes:

  * Mutex handling:

    * Previously:

      * ``openthread_api_mutex_lock``
      * ``openthread_api_mutex_try_lock``
      * ``openthread_api_mutex_unlock``

    * Now use:

      * :c:func:`openthread_mutex_lock`
      * :c:func:`openthread_mutex_try_lock`
      * :c:func:`openthread_mutex_unlock`

  * OpenThread starting:

    * Previously: ``openthread_start``
    * Now use: :c:func:`openthread_run`

  * Callback registration:

    * Previously:

      * ``openthread_state_changed_cb_register``
      * ``openthread_state_changed_cb_unregister``

    * Now use:

      * :c:func:`openthread_state_changed_callback_register`
      * :c:func:`openthread_state_changed_callback_unregister`

  * Callback structure:

    * Previously: ``openthread_state_changed_cb``
    * Now use: :c:struct:`openthread_state_changed_callback`

  * The following :c:struct:`openthread_context` struct fields are deprecated and shall not be used
    in new code anymore:

    * ``instance``
    * ``api_lock``
    * ``work_q``
    * ``api_work``
    * ``state_change_cbs``

  * The new functions that were not present before:

    * :c:func:`openthread_init` to initialize the OpenThread stack.
    * :c:func:`openthread_stop` to stop and disable the OpenThread stack.
    * :c:func:`openthread_set_receive_cb` to set the receive callback for the OpenThread stack.

* The OpenThread-related Kconfig options from ``subsys/net/l2/openthread/Kconfig``
  have been moved to :zephyr_file:`modules/openthread/Kconfig`. All Kconfig options remain the same.
  You can still use them in the same way as before, but to modify them, use the new path in the
  menuconfig or guiconfig.

* If the :kconfig:option:`CONFIG_NET_L2_OPENTHREAD` Kconfig option is enabled, Zephyr's L2 layer
  will use the new OpenThread module API as its backend. The L2 layer no longer implements
  OpenThread itself, but delegates the implementation to the module.

* For existing applications using OpenThread through Zephyr's networking stack:

  * Your application should continue to work, as the old APIs are still available for compatibility.
    However, you are encouraged to migrate to the new APIs for future-proofing and use the new
    modular structure.
  * Update any references to OpenThread Kconfig options to use the new path
    (``modules/openthread/Kconfig``) in your configuration tools.

* For applications using :c:struct:`openthread_context` or other deprecated APIs:

  * Begin migrating to the new APIs. The deprecated APIs will be removed in a future release.
  * Avoid direct use of :c:struct:`openthread_context` and related fields; use the new
    initialization and callback registration functions instead.

* For new applications or those using OpenThread without Zephyr L2:

  * Use the new initialization (:c:func:`openthread_init`), run (:c:func:`openthread_run`),
    and callback registration APIs (:c:func:`openthread_state_change_callback_register`).
  * You can now use OpenThread directly, without enabling Zephyr's L2 or IEEE802.15.4 layers, if
    your use case allows.

SPI
===

* Renamed the device tree property ``port_sel`` to ``port-sel``.
* Renamed the device tree property ``chip_select`` to ``chip-select``.
* The binding file for :dtcompatible:`andestech,atcspi200` has been renamed to have a name
  matching the compatible string.

xSPI
====

* On STM32 devices, external memories device tree descriptions for size and address are now split
  in two separate properties to comply with specification recommendations.

  For instance, following external flash description ``reg = <0x70000000 DT_SIZE_M(64)>; /* 512 Mbits /``
  is changed to ``reg = <0>;`` ``size = <DT_SIZE_M(512)>; / 512 Mbits */``.

  Note that the property gives the actual size of the memory device in bits.
  Previous mapping address information is now described in xspi node at SoC dtsi level.

Video
=====

* 8 bit RAW Bayer formats BGGR8 / GBRG8 / GRBG8 / RGGB8 have been renamed by adding
  a S prefix in front:

  ``VIDEO_PIX_FMT_BGGR8`` becomes ``VIDEO_PIX_FMT_SBGGR8``
  ``VIDEO_PIX_FMT_GBRG8`` becomes ``VIDEO_PIX_FMT_SGBRG8``
  ``VIDEO_PIX_FMT_GRBG8`` becomes ``VIDEO_PIX_FMT_SGRBG8``
  ``VIDEO_PIX_FMT_RGGB8`` becomes ``VIDEO_PIX_FMT_SRGGB8``

* On STM32 devices, the DCMI driver (:dtcompatible:`st,stm32-dcmi`) now relies on endpoint based
  video-interfaces.yaml bindings for sensor interface properties (such as bus width and
  synchronization signals).
  Also the ``capture-rate`` property has been replaced by the usage of the frame interval API
  :c:func:`video_set_frmival`.
  See (:github:`89627`).

* video_endpoint_id enum has been dropped. It is no longer a parameter in any video API.

* video_buf_type enum has been added. It is a required parameter in the following video APIs:

  ``set_stream``
  ``video_stream_start``
  ``video_stream_stop``

Audio
=====

* The binding file for :dtcompatible:`cirrus,cs43l22` has been renamed to have a name
  matching the compatible string.

Other subsystems
****************

hawkBit
=======

* When :kconfig:option:`CONFIG_HAWKBIT_CUSTOM_DEVICE_ID` is enabled, device_id will no longer
  be prepended with :kconfig:option:`CONFIG_BOARD`. It is the user's responsibility to write a
  callback that prepends the board name if needed.

Modules
*******

CMSIS
=====

* Cortex-M boards/socs now require the ``CMSIS_6`` module to build properly (instead of ``cmsis``
  which was CMSIS 5.9.0).
  If trying to build a Cortex-M board, do a ``west update`` to make sure that ``CMSIS_6`` module is
  available before running ``west build`` or other commands.

  Boards or SOCs or modules using the older ``cmsis`` module either with a local copy or via the
  :kconfig:option:`CONFIG_ZEPHYR_CMSIS_MODULE_DIR` are requested to move to the ``CMSIS_6`` module
  which can be accessed via the :kconfig:option:`CONFIG_ZEPHYR_CMSIS_6_MODULE_DIR` configuration.

  Note: Zephyr will continue using the older ``cmsis`` module for Cortex-A and Cortex-R targets.

Architectures
*************

* Moved :kconfig:option:`CONFIG_SRAM_VECTOR_TABLE` from ``zephyr/Kconfig.zephyr`` to
  ``zephyr/arch/Kconfig`` and added dependency to :kconfig:option:`CONFIG_XIP`,
  :kconfig:option:`CONFIG_ARCH_HAS_VECTOR_TABLE_RELOCATION` and
  :kconfig:option:`CONFIG_ROMSTART_RELOCATION_ROM` to support relocation
  of vector table in RAM.
