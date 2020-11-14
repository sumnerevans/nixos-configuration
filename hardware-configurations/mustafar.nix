{ config, lib, pkgs, modulesPath, ... }:
{
  boot = {
    blacklistedKernelModules = [ "snd_hda_intel" "snd_soc_skl" ];
    kernelPatches = [
      {
        name = "kohaku-sound";
        patch = null;
        extraConfig = ''
          B43 m
          B43_SDIO y
          BATTERY_SBS m
          CPU_FREQ_GOV_POWERSAVE y
          CRYPTO_AES_NI_INTEL y
          DEBUG_GPIO y
          DMADEVICES y
          DW_DMAC m
          EARLY_PRINTK_DBGP y
          GPIO_SYSFS y
          I2C_CROS_EC_TUNNEL m
          INTEL_IDLE y
          INTEL_IDMA64 y
          INTEL_PMC_CORE y
          INTEL_RAPL y
          INTEL_SOC_DTS_THERMAL y
          KEYBOARD_GPIO y
          MFD_INTEL_LPSS_ACPI y
          MFD_INTEL_LPSS_PCI y
          MOUSE_BCM5974 m
          MOUSE_SYNAPTICS_USB m
          PCI_MSI y
          PINCTRL_BAYTRAIL y
          PINCTRL_BROXTON y
          PINCTRL_SUNRISEPOINT y
          RTL8187 m
          RTL8192CU m
          RTLLIB m
          SKGE m
          SKY2 m
          SND_HDA_CODEC_ANALOG m
          SND_HDA_CODEC_CA0110 m
          SND_HDA_CODEC_CA0132 m
          SND_HDA_CODEC_CA0132_DSP y
          SND_HDA_CODEC_CIRRUS m
          SND_HDA_CODEC_CMEDIA m
          SND_HDA_CODEC_CONEXANT m
          SND_HDA_CODEC_REALTEK m
          SND_HDA_CODEC_SI3054 m
          SND_HDA_CODEC_SIGMATEL m
          SND_HDA_CODEC_VIA m
          SND_HDA_POWER_SAVE_DEFAULT 15
          SND_SOC_ADAU7002 m
          SND_SOC_INTEL_BXT_DA7219_MAX98357A_MACH m
          SND_SOC_INTEL_CML_LP_DA7219_MAX98357A_MACH m
          SND_SOC_INTEL_SOF_CML_RT1011_RT5682_MACH m
          SND_SOC_INTEL_SOF_RT5682_MACH m
          SND_SOC_MAX98927 m
          SND_SOC_SOF_ACPI m
          SND_SOC_SOF_COMETLAKE_LP_SUPPORT y
          SND_SOC_SOF_HDA_LINK y
          SND_SOC_SOF_INTEL_TOPLEVEL y
          SND_SOC_SOF_PCI m
          SND_SOC_SOF_TOPLEVEL y
          SND_SOC_SSM4567 m
          SX9310 m
          X86_PKG_TEMP_THERMAL y
        '';
      }
    ];
  };

  networking = {
    useDHCP = false;
    interfaces.wlp0s20f3.useDHCP = true;
  };

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
