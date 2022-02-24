# This is a FSL Android Reference Design platform based on i.MX8MQ board
# It will inherit from FSL core product which in turn inherit from Google generic

IMX_DEVICE_PATH := device/trucrux/imx8m/imx8mq_trux_q01

PRODUCT_IMX_DRM := true

# copy drm specific files before inherit trux_iMX8MQ.mk, otherwise copy is ignored
PRODUCT_COPY_FILES += \
	$(IMX_DEVICE_PATH)/audio_policy_configuration_drm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
	$(IMX_DEVICE_PATH)/init.iMX8MQ.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.nxp.iMX8MQ.main.rc \
	$(IMX_DEVICE_PATH)/init.iMX8MQ.drm.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.nxp.iMX8MQ.rc \
	$(TOPDIR)device/nxp/imx8m/tee-supplicant.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/tee-supplicant.rc \


$(call inherit-product, $(TOPDIR)device/nxp/imx8m/optee-packages.mk)
$(call inherit-product, $(TOPDIR)$(IMX_DEVICE_PATH)/trux_imx8mq.mk)

TARGET_KERNEL_DEFCONFIG := imx8_trux_android_defconfig


# Overrides
PRODUCT_NAME := imx8mq-trux-q01_drm

CFG_DRM_SECURE_DATA_PATH ?= y
CFG_RDC_SECURE_DATA_PATH ?= y

ifeq ($(CFG_DRM_SECURE_DATA_PATH),y)
CFG_SECURE_DATA_PATH := y
SOONG_CONFIG_IMXPLUGIN += CFG_SECURE_DATA_PATH
SOONG_CONFIG_IMXPLUGIN_CFG_SECURE_DATA_PATH = y
CFG_TEE_SDP_MEM_BASE := 0xcc000000
CFG_TEE_SDP_MEM_SIZE := 0x02000000
ifeq ($(CFG_RDC_SECURE_DATA_PATH),y)
DECRYPTED_BUFFER_START	:= $(CFG_TEE_SDP_MEM_BASE)
DECRYPTED_BUFFER_LEN	:= $(CFG_TEE_SDP_MEM_SIZE)
DECODED_BUFFER_START	:= 0xCE000000
DECODED_BUFFER_LEN		:= 0x30000000
endif
endif

TARGET_BOARD_DTS_CONFIG := \
        iMX8MQ-trux-emmc-wifi-lvds:iMX8MQ-trux-emmc-wifi-lvds.dtb \
        iMX8MQ-trux-emmc-wifi-dual-display:iMX8MQ-trux-emmc-wifi-dual-display.dtb \
        iMX8MQ-trux-emmc-wifi-hdmi:iMX8MQ-trux-emmc-wifi-hdmi.dtb \
        iMX8MQ-trux-sd-emmc-lvds:iMX8MQ-trux-sd-emmc-lvds.dtb \
        iMX8MQ-trux-sd-emmc-dual-display:iMX8MQ-trux-sd-emmc-dual-display.dtb \
        iMX8MQ-trux-sd-emmc-hdmi:iMX8MQ-trux-sd-emmc-hdmi.dtb

# Exoplayer
PRODUCT_PACKAGES += \
	exoplayer \

# Playready
PRODUCT_COPY_FILES += \
	vendor/nxp/drm_artifacts/playready/Samples/devcert.dat:$(TARGET_COPY_OUT_VENDOR)/playready/devcert.dat \
	vendor/nxp/drm_artifacts/playready/Samples/priv.dat:$(TARGET_COPY_OUT_VENDOR)/playready/priv.dat \
	vendor/nxp/drm_artifacts/playready/bgroupcert.dat:$(TARGET_COPY_OUT_VENDOR)/playready/bgroupcert.dat \
	vendor/nxp/drm_artifacts/playready/zgpriv_protected.dat:$(TARGET_COPY_OUT_VENDOR)/playready/zgpriv_protected.dat \

ifneq ($(CFG_BUILD_DRM_FROM_SOURCES),y)
PRODUCT_COPY_FILES += \
	vendor/nxp/drm_artifacts/playready/ta/82dbae9c-9ce0-47e0-a1cb4048cfdb84aa.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/82dbae9c-9ce0-47e0-a1cb4048cfdb84aa.ta \
	vendor/nxp/drm_artifacts/playready/libdrmplayreadyplugin.so:$(TARGET_COPY_OUT_VENDOR)/lib64/mediadrm/libdrmplayreadyplugin.so \
	vendor/nxp/drm_artifacts/playready/optee_playready_test:$(TARGET_COPY_OUT_VENDOR)/bin/optee_playready_test
endif

ifneq ($(CFG_BUILD_DRM_FROM_SOURCES),y)
# Widevine
PRODUCT_COPY_FILES += \
	vendor/nxp/drm_artifacts/widevine/lib/liboemcrypto.so:$(TARGET_COPY_OUT_VENDOR)/lib/liboemcrypto.so \
	vendor/nxp/drm_artifacts/widevine/lib/libwvdrmengine.so:$(TARGET_COPY_OUT_VENDOR)/lib/mediadrm/libwvdrmengine.so \
	vendor/nxp/drm_artifacts/widevine/lib/libvtswidevine.so:$(TARGET_COPY_OUT_VENDOR)/lib/drm-vts-test-libs/libvtswidevine.so \
	vendor/nxp/drm_artifacts/widevine/lib64/liboemcrypto.so:$(TARGET_COPY_OUT_VENDOR)/lib64/liboemcrypto.so \
	vendor/nxp/drm_artifacts/widevine/lib64/libwvdrmengine.so:$(TARGET_COPY_OUT_VENDOR)/lib64/mediadrm/libwvdrmengine.so \
	vendor/nxp/drm_artifacts/widevine/lib64/libvtswidevine.so:$(TARGET_COPY_OUT_VENDOR)/lib64/drm-vts-test-libs/libvtswidevine.so \
	vendor/nxp/drm_artifacts/widevine/ta/706f6574-7765-6469-77656e6942656665.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/706f6574-7765-6469-77656e6942656665.ta
endif
