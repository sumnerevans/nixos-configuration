{
  # Lock screen and greeter layouts from the exported DMS configuration.
  lockScreenWidgetInstances = [
    {
      id = "lock_clock";
      widgetType = "desktopClock";
      enabled = true;
      config = {
        displayPreferences = [ "all" ];
        syncPositionAcrossScreens = true;
        style = "expressive";
        transparency = 0;
        weight = 0;
        twoTone = true;
        showDate = false;
        showDigitalSeconds = false;
        showAnalogNumbers = false;
        showAnalogSeconds = true;
        autoPosition = true;
        colorMode = "default";
        customColor = "#ffffff";
      };
    }
    {
      id = "lock_date";
      widgetType = "lockDate";
      enabled = true;
      config = {
        displayPreferences = [ "all" ];
        syncPositionAcrossScreens = true;
        format = "short";
        colorMode = "default";
        customColor = "#ffffff";
      };
    }
    {
      id = "lock_auth";
      widgetType = "lockAuth";
      enabled = true;
      config = {
        displayPreferences = [ "all" ];
        syncPositionAcrossScreens = true;
        style = "expressive";
        profileVisibility = "always";
        passwordVisibility = "always";
      };
    }
    {
      id = "lock_notifications";
      widgetType = "lockNotifications";
      enabled = false;
      config = {
        displayPreferences = [ "all" ];
        syncPositionAcrossScreens = true;
        mode = 2;
      };
    }
    {
      id = "lock_status";
      widgetType = "lockStatus";
      enabled = true;
      config = {
        displayPreferences = [ "all" ];
        syncPositionAcrossScreens = true;
        showMediaPlayer = true;
        showWeather = true;
        background = false;
      };
    }
    {
      id = "lock_power";
      widgetType = "lockPower";
      enabled = true;
      config = {
        displayPreferences = [ "all" ];
        syncPositionAcrossScreens = true;
        shape = "round";
      };
    }
  ];
  greeterWidgetInstances = [
    {
      id = "lock_clock";
      widgetType = "desktopClock";
      enabled = true;
      config = {
        displayPreferences = [ "all" ];
        syncPositionAcrossScreens = true;
        style = "expressive";
        transparency = 0;
        weight = 0;
        twoTone = true;
        showDate = false;
        showDigitalSeconds = false;
        showAnalogNumbers = false;
        showAnalogSeconds = true;
        autoPosition = true;
        colorMode = "default";
        customColor = "#ffffff";
      };
    }
    {
      id = "lock_date";
      widgetType = "lockDate";
      enabled = true;
      config = {
        displayPreferences = [ "all" ];
        syncPositionAcrossScreens = true;
        format = "short";
        colorMode = "default";
        customColor = "#ffffff";
      };
    }
    {
      id = "lock_auth";
      widgetType = "lockAuth";
      enabled = true;
      config = {
        displayPreferences = [ "all" ];
        syncPositionAcrossScreens = true;
        style = "expressive";
        profileVisibility = "always";
        passwordVisibility = "always";
      };
    }
    {
      id = "lock_status";
      widgetType = "lockStatus";
      enabled = true;
      config = {
        displayPreferences = [ "all" ];
        syncPositionAcrossScreens = true;
        showMediaPlayer = true;
        showWeather = true;
        background = false;
      };
    }
    {
      id = "lock_power";
      widgetType = "lockPower";
      enabled = true;
      config = {
        displayPreferences = [ "all" ];
        syncPositionAcrossScreens = true;
        shape = "round";
      };
    }
    {
      id = "greeter_session";
      widgetType = "greeterSession";
      enabled = true;
      config = {
        displayPreferences = [ "all" ];
        syncPositionAcrossScreens = true;
      };
    }
  ];
  radiusStrength = 38;
  clockFormat = "24h";
  lockScreenShowWeather = true;
  dockConfigs = [
    {
      id = "dock";
      name = "Dock";
      enabled = false;
      screenPreferences = [ "all" ];
      showOnLastDisplay = true;
      position = 1;
      mode = "compact";
      taskbarAlign = "center";
      widgetExpansion = "popout";
      iconSize = 50;
      spacing = 4;
      itemSpacing = 4;
      margin = 0;
      bottomGap = 0;
      transparency = 1;
      followInterfaceStyle = true;
      autoHide = true;
      smartAutoHide = false;
      useOverlayLayer = false;
      editOnRightClick = false;
      showOnFullscreen = false;
      openOnOverview = false;
      groupByApp = false;
      separatePinnedAndRunningApps = false;
      restoreSpecialWorkspaceOnClick = false;
      isolateDisplays = false;
      indicatorStyle = "circle";
      borderEnabled = false;
      borderColor = "surfaceText";
      borderOpacity = 1;
      borderThickness = 1;
      launcherEnabled = false;
      launcherLogoMode = "apps";
      launcherLogoCustomPath = "";
      launcherLogoColorOverride = "";
      launcherLogoSizeOffset = 0;
      launcherLogoBrightness = 0.5;
      launcherLogoContrast = 1;
      maxVisibleApps = 0;
      maxVisibleRunningApps = 0;
      showOverflowBadge = true;
      showTrash = false;
      trashFileManager = "default";
      trashCustomCommand = "";
      magnification = false;
      magnificationScale = 130;
      magnificationProfile = "parabolic";
      magnificationExpand = false;
      order = [ ];
      widgets = [
        {
          id = "dock_launcher";
          widgetId = "dockLauncher";
          enabled = true;
        }
        {
          id = "dock_apps";
          widgetId = "appsDock";
          enabled = true;
        }
        {
          id = "dock_trash";
          widgetId = "dockTrash";
          enabled = true;
        }
      ];
    }
  ];
  currentThemeName = "dynamic";
  currentThemeCategory = "dynamic";
  customThemeFile = "";
  registryThemeVariants = { };
  matugenScheme = "scheme-fruit-salad";
  runUserMatugenTemplates = true;
  matugenTargetMonitor = "";
  popupTransparency = 1;
  dockTransparency = 1;
  widgetBackgroundColor = "sch";
  widgetColorMode = "default";
  controlCenterTileColorMode = "primary";
  buttonColorMode = "primary";
  cornerRadius = 12;
  layoutRadiusOverride = -1;
  layoutBorderSize = -1;
  use24HourClock = true;
  showSeconds = true;
  padHours12Hour = false;
  useFahrenheit = true;
  windSpeedUnit = "kmh";
  nightModeEnabled = false;
  animationSpeed = 1;
  customAnimationDuration = 500;
  syncComponentAnimationSpeeds = true;
  popoutAnimationSpeed = 1;
  popoutCustomAnimationDuration = 150;
  modalAnimationSpeed = 1;
  modalCustomAnimationDuration = 150;
  enableRippleEffects = true;
  wallpaperFillMode = "Fill";
  blurredWallpaperLayer = false;
  blurWallpaperOnOverview = true;
  showLauncherButton = true;
  showWorkspaceSwitcher = true;
  showFocusedWindow = true;
  showWeather = true;
  showMusic = true;
  showClipboard = true;
  showCpuUsage = true;
  showMemUsage = true;
  showCpuTemp = true;
  showGpuTemp = true;
  selectedGpuIndex = 0;
  enabledGpuPciIds = [ ];
  showSystemTray = true;
  showClock = true;
  showNotificationButton = true;
  showBattery = true;
  showControlCenterButton = true;
  showCapsLockIndicator = true;
  controlCenterShowNetworkIcon = true;
  controlCenterShowBluetoothIcon = true;
  controlCenterShowAudioIcon = true;
  controlCenterShowAudioPercent = false;
  controlCenterShowVpnIcon = true;
  controlCenterShowBrightnessIcon = false;
  controlCenterShowBrightnessPercent = false;
  controlCenterShowMicIcon = false;
  controlCenterShowMicPercent = true;
  controlCenterShowBatteryIcon = false;
  controlCenterShowPrinterIcon = false;
  controlCenterShowScreenSharingIcon = true;
  showPrivacyButton = true;
  privacyShowMicIcon = false;
  privacyShowCameraIcon = false;
  privacyShowScreenShareIcon = false;
  controlCenterWidgets = [
    {
      id = "user";
      enabled = true;
      w = 5;
      h = 1;
    }
    {
      id = "settings";
      enabled = true;
      w = 1;
      h = 1;
      small = true;
    }
    {
      id = "lock";
      enabled = true;
      w = 1;
      h = 1;
      small = true;
    }
    {
      id = "power";
      enabled = true;
      w = 1;
      h = 1;
      small = true;
    }
    {
      id = "volumeSlider";
      enabled = true;
      w = 4;
      h = 1;
    }
    {
      id = "brightnessSlider";
      enabled = true;
      w = 4;
      h = 1;
    }
    {
      id = "wifi";
      enabled = true;
      w = 4;
      h = 1;
    }
    {
      id = "bluetooth";
      enabled = true;
      w = 4;
      h = 1;
    }
    {
      id = "audioOutput";
      enabled = true;
      w = 4;
      h = 1;
    }
    {
      id = "audioInput";
      enabled = true;
      w = 4;
      h = 1;
    }
    {
      id = "nightMode";
      enabled = true;
      w = 4;
      h = 1;
    }
    {
      id = "darkMode";
      enabled = true;
      w = 4;
      h = 1;
    }
    {
      id = "plugin_dmsScreenshot";
      enabled = true;
      w = 4;
      h = 1;
    }
    {
      id = "builtin_cups";
      enabled = true;
      w = 4;
      h = 1;
    }
    {
      id = "edit";
      enabled = true;
      w = 1;
      h = 1;
      small = true;
    }
    {
      id = "runningApps";
      enabled = true;
      w = 4;
      h = 1;
      small = true;
      col = 0;
      row = 7;
    }
  ];
  showWorkspaceIndex = true;
  showWorkspaceName = false;
  showWorkspacePadding = false;
  workspaceScrolling = false;
  showWorkspaceApps = false;
  workspaceDragReorder = true;
  maxWorkspaceIcons = 3;
  workspaceAppIconSizeOffset = 0;
  groupWorkspaceApps = true;
  workspaceFollowFocus = false;
  showOccupiedWorkspacesOnly = false;
  reverseScrolling = false;
  dwlShowAllTags = false;
  workspaceColorMode = "default";
  workspaceOccupiedColorMode = "none";
  workspaceUnfocusedColorMode = "default";
  workspaceUrgentColorMode = "default";
  workspaceFocusedBorderEnabled = false;
  workspaceFocusedBorderColor = "primary";
  workspaceFocusedBorderThickness = 2;
  workspaceNameIcons = { };
  waveProgressEnabled = true;
  scrollTitleEnabled = true;
  audioVisualizerEnabled = true;
  audioScrollMode = "volume";
  audioWheelScrollAmount = 5;
  clockCompactMode = false;
  focusedWindowCompactMode = false;
  runningAppsCompactMode = true;
  barMaxVisibleApps = 0;
  barMaxVisibleRunningApps = 0;
  barShowOverflowBadge = true;
  appsDockHideIndicators = false;
  appsDockColorizeActive = false;
  appsDockActiveColorMode = "primary";
  appsDockEnlargeOnHover = false;
  appsDockEnlargePercentage = 125;
  appsDockIconSizePercentage = 100;
  keyboardLayoutNameCompactMode = false;
  runningAppsCurrentWorkspace = false;
  runningAppsGroupByApp = false;
  runningAppsCurrentMonitor = false;
  appIdSubstitutions = [ ];
  centeringMode = "index";
  clockDateFormat = "dddd, d MMMM yyyy (yyyy-MM-dd)";
  lockDateFormat = "dddd, d MMMM yyyy";
  greeterRememberLastSession = true;
  greeterRememberLastUser = true;
  greeterEnableFprint = false;
  greeterEnableU2f = false;
  greeterWallpaperPath = "";
  greeterUse24HourClock = true;
  greeterShowSeconds = false;
  greeterPadHours12Hour = false;
  greeterLockDateFormat = "";
  greeterFontFamily = "";
  greeterWallpaperFillMode = "";
  mediaSize = 1;
  appLauncherViewMode = "list";
  spotlightModalViewMode = "list";
  browserPickerViewMode = "grid";
  browserUsageHistory = { };
  appPickerViewMode = "grid";
  filePickerUsageHistory = { };
  sortAppsAlphabetically = false;
  appLauncherGridColumns = 4;
  spotlightSectionViewModes = {
    plugin_webSearch = "list";
  };
  appDrawerSectionViewModes = { };
  dankLauncherV2Size = "compact";
  dankLauncherV2BorderEnabled = false;
  dankLauncherV2BorderThickness = 2;
  dankLauncherV2BorderColor = "primary";
  dankLauncherV2ShowFooter = true;
  dankLauncherV2UnloadOnClose = false;
  useAutoLocation = true;
  weatherEnabled = true;
  networkPreference = "wifi";
  iconThemeDark = "Papirus-Dark";
  iconThemeLight = "Papirus";
  iconThemePerMode = true;
  cursorSettings = {
    theme = "System Default";
    size = 24;
    hyprland = {
      hideOnKeyPress = true;
      hideOnTouch = false;
      inactiveTimeout = 0;
    };
    dwl = {
      cursorHideTimeout = 0;
    };
  };
  launcherLogoMode = "apps";
  launcherLogoCustomPath = "";
  launcherLogoColorOverride = "";
  launcherLogoColorInvertOnMode = false;
  launcherLogoBrightness = 0.5;
  launcherLogoContrast = 1;
  launcherLogoSizeOffset = 0;
  fontFamily = "Inter Variable";
  monoFontFamily = "Fira Code";
  fontWeight = 400;
  fontScale = 1;
  notepadUseMonospace = true;
  notepadFontFamily = "";
  notepadFontSize = 14;
  notepadShowLineNumbers = false;
  notepadTransparencyOverride = -1;
  notepadLastCustomTransparency = 0.7;
  soundsEnabled = true;
  useSystemSoundTheme = false;
  soundLogin = true;
  soundNewNotification = true;
  soundVolumeChanged = true;
  soundPluggedIn = true;
  acMonitorTimeout = 600;
  acLockTimeout = 180;
  acSuspendTimeout = 0;
  acSuspendBehavior = 0;
  acProfileName = "";
  batteryMonitorTimeout = 300;
  batteryLockTimeout = 180;
  batterySuspendTimeout = 900;
  batterySuspendBehavior = 0;
  batteryProfileName = "0";
  batteryChargeLimit = 100;
  batteryLowThreshold = 15;
  batteryCriticalThreshold = 5;
  batteryNotifyLow = true;
  batteryAutoPowerSaver = true;
  lockBeforeSuspend = true;
  loginctlLockIntegration = true;
  fadeToLockEnabled = true;
  fadeToLockGracePeriod = 5;
  fadeToDpmsEnabled = true;
  fadeToDpmsGracePeriod = 5;
  launchPrefix = "";
  brightnessDevicePins = { };
  wifiNetworkPins = {
    preferredWifi = [
      "kashyyyk"
    ];
  };
  bluetoothDevicePins = { };
  audioInputDevicePins = {
    preferredInput = [
      "alsa_input.usb-C-Media_Electronics_Inc._USB_Audio_Device-00.mono-fallback"
    ];
  };
  audioOutputDevicePins = {
    preferredOutput = [
      "alsa_output.usb-Lenovo_ThinkPad_USB-C_Dock_Audio_000000000000-00.analog-stereo"
      "alsa_output.usb-Audioengine_Audioengine_2_-00.analog-stereo"
    ];
  };
  gtkThemingEnabled = false;
  qtThemingEnabled = false;
  syncModeWithPortal = true;
  terminalsAlwaysDark = false;
  runDmsMatugenTemplates = true;
  matugenTemplateGtk = true;
  matugenTemplateHyprland = true;
  matugenTemplateMangowc = true;
  matugenTemplateQt5ct = true;
  matugenTemplateQt6ct = true;
  matugenTemplateFirefox = true;
  matugenTemplatePywalfox = true;
  matugenTemplateZenBrowser = true;
  matugenTemplateVesktop = true;
  matugenTemplateEquibop = true;
  matugenTemplateGhostty = true;
  matugenTemplateKitty = true;
  matugenTemplateFoot = true;
  matugenTemplateAlacritty = true;
  matugenTemplateNeovim = true;
  matugenTemplateWezterm = true;
  matugenTemplateDgop = true;
  matugenTemplateKcolorscheme = true;
  matugenTemplateVscode = true;
  matugenTemplateEmacs = true;
  matugenTemplateZed = true;
  showDock = false;
  dockAutoHide = true;
  dockSmartAutoHide = false;
  dockGroupByApp = false;
  dockOpenOnOverview = false;
  dockPosition = 1;
  dockSpacing = 4;
  dockBottomGap = 0;
  dockMargin = 0;
  dockIconSize = 50;
  dockIndicatorStyle = "circle";
  dockBorderEnabled = false;
  dockBorderColor = "surfaceText";
  dockBorderOpacity = 1;
  dockBorderThickness = 1;
  dockIsolateDisplays = false;
  dockLauncherEnabled = false;
  dockLauncherLogoMode = "apps";
  dockLauncherLogoCustomPath = "";
  dockLauncherLogoColorOverride = "";
  dockLauncherLogoSizeOffset = 0;
  dockLauncherLogoBrightness = 0.5;
  dockLauncherLogoContrast = 1;
  dockMaxVisibleApps = 0;
  dockMaxVisibleRunningApps = 0;
  dockShowOverflowBadge = true;
  notificationOverlayEnabled = false;
  notificationPopupShadowEnabled = true;
  notificationPopupPrivacyMode = false;
  modalDarkenBackground = true;
  lockScreenShowPowerActions = true;
  lockScreenShowSystemIcons = true;
  lockScreenShowTime = true;
  lockScreenShowDate = true;
  lockScreenShowProfileImage = true;
  lockScreenShowPasswordField = true;
  lockScreenShowMediaPlayer = true;
  lockScreenPowerOffMonitorsOnLock = false;
  lockAtStartup = false;
  enableFprint = false;
  maxFprintTries = 15;
  enableU2f = false;
  u2fMode = "or";
  lockScreenActiveMonitor = "all";
  lockScreenInactiveColor = "#000000";
  lockScreenNotificationMode = 0;
  hideBrightnessSlider = false;
  notificationTimeoutLow = 10000;
  notificationTimeoutNormal = 30000;
  notificationTimeoutCritical = 0;
  notificationCompactMode = false;
  notificationPopupPosition = 0;
  notificationAnimationSpeed = 1;
  notificationCustomAnimationDuration = 400;
  notificationHistoryEnabled = true;
  notificationHistoryMaxCount = 50;
  notificationHistoryMaxAgeDays = 7;
  notificationHistorySaveLow = true;
  notificationHistorySaveNormal = true;
  notificationHistorySaveCritical = true;
  notificationRules = [ ];
  osdAlwaysShowValue = false;
  osdPosition = 5;
  osdVolumeEnabled = true;
  osdMediaVolumeEnabled = true;
  osdMediaPlaybackEnabled = false;
  osdBrightnessEnabled = true;
  osdIdleInhibitorEnabled = true;
  osdMicMuteEnabled = true;
  osdCapsLockEnabled = true;
  osdPowerProfileEnabled = true;
  osdAudioOutputEnabled = true;
  powerActionConfirm = true;
  powerActionHoldDuration = 0.5;
  powerMenuActions = [
    "reboot"
    "logout"
    "poweroff"
    "lock"
    "suspend"
    "restart"
  ];
  powerMenuDefaultAction = "logout";
  powerMenuGridLayout = false;
  customPowerActionLock = "";
  customPowerActionLogout = "";
  customPowerActionSuspend = "";
  customPowerActionHibernate = "";
  customPowerActionReboot = "";
  customPowerActionPowerOff = "";
  updaterHideWidget = false;
  updaterUseCustomCommand = false;
  updaterCustomCommand = "";
  updaterTerminalAdditionalParams = "";
  displayNameMode = "system";
  screenPreferences = {
    wallpaper = [
      "all"
    ];
  };
  showOnLastDisplay = { };
  hyprlandOutputSettings = { };
  displayProfiles = { };
  activeDisplayProfile = { };
  displayProfileAutoSelect = false;
  displayShowDisconnected = false;
  displaySnapToEdge = true;
  barConfigs = [
    {
      id = "default";
      name = "Main Bar";
      enabled = true;
      position = 0;
      screenPreferences = [
        "all"
      ];
      showOnLastDisplay = true;
      leftWidgets = [
        {
          id = "launcherButton";
          enabled = true;
          launcherLogoMode = "apps";
          launcherLogoCustomPath = "";
          launcherLogoColorOverride = "";
          launcherLogoBrightness = 0.5;
          launcherLogoContrast = 1;
          launcherLogoSizeOffset = 0;
        }
        {
          id = "workspaceSwitcher";
          enabled = true;
          showWorkspaceIndex = true;
          showWorkspaceName = false;
          showWorkspacePadding = false;
          showWorkspaceApps = false;
          workspaceDragReorder = true;
          maxWorkspaceIcons = 3;
          workspaceAppIconSizeOffset = 0;
          groupWorkspaceApps = true;
          workspaceFollowFocus = false;
          showOccupiedWorkspacesOnly = false;
          reverseScrolling = false;
          dwlShowAllTags = false;
          workspaceColorMode = "default";
          workspaceOccupiedColorMode = "none";
          workspaceUnfocusedColorMode = "default";
          workspaceUrgentColorMode = "default";
          workspaceFocusedBorderEnabled = false;
          workspaceFocusedBorderColor = "primary";
          workspaceFocusedBorderThickness = 2;
        }
      ];
      centerWidgets = [
        {
          id = "music";
          enabled = true;
          mediaSize = 1;
          audioScrollMode = "volume";
        }
        {
          id = "clock";
          enabled = true;
          clockCompactMode = false;
        }
      ];
      rightWidgets = [
        {
          id = "worldClock";
          enabled = true;
        }
        {
          id = "systemTray";
          enabled = true;
        }
        {
          id = "clipboard";
          enabled = true;
        }
        {
          id = "cpuUsage";
          enabled = true;
        }
        {
          id = "memUsage";
          enabled = true;
        }
        {
          id = "offlinemsmtp";
          enabled = true;
        }
        {
          id = "voxtype";
          enabled = true;
        }
        {
          id = "notificationButton";
          enabled = true;
        }
        {
          id = "battery";
          enabled = true;
        }
        {
          id = "controlCenterButton";
          enabled = true;
          showNetworkIcon = true;
          showVpnIcon = true;
          showBluetoothIcon = true;
          showAudioIcon = true;
          showAudioPercent = false;
          showMicIcon = false;
          showMicPercent = true;
          showBrightnessIcon = false;
          showBrightnessPercent = false;
          showBatteryIcon = false;
          showPrinterIcon = false;
          showScreenSharingIcon = true;
        }
      ];
      spacing = 4;
      innerPadding = 4;
      bottomGap = 0;
      transparency = 1;
      widgetTransparency = 1;
      squareCorners = false;
      noBackground = false;
      gothCornersEnabled = false;
      gothCornerRadiusOverride = false;
      gothCornerRadiusValue = 12;
      borderEnabled = false;
      borderColor = "surfaceText";
      borderOpacity = 1;
      borderThickness = 1;
      widgetOutlineEnabled = false;
      widgetOutlineColor = "primary";
      widgetOutlineOpacity = 1;
      widgetOutlineThickness = 1;
      fontScale = 1;
      autoHide = false;
      autoHideDelay = 250;
      showOnWindowsOpen = false;
      openOnOverview = false;
      visible = true;
      popupGapsAuto = true;
      popupGapsManual = 4;
      maximizeDetection = true;
      scrollEnabled = true;
      scrollXBehavior = "focusWindow";
      scrollYBehavior = "workspace";
      shadowIntensity = 0;
      shadowOpacity = 60;
      shadowColorMode = "text";
      shadowCustomColor = "#000000";
      followInterfaceStyle = true;
      widgetFollowInterfaceStyle = true;
    }
  ];
  desktopClockEnabled = false;
  desktopClockStyle = "analog";
  desktopClockTransparency = 0.8;
  desktopClockColorMode = "primary";
  desktopClockCustomColor = {
    r = 1;
    g = 1;
    b = 1;
    a = 1;
    hsvHue = -1;
    hsvSaturation = 0;
    hsvValue = 1;
    hslHue = -1;
    hslSaturation = 0;
    hslLightness = 1;
    valid = true;
  };
  desktopClockShowDate = true;
  desktopClockShowAnalogNumbers = false;
  desktopClockShowAnalogSeconds = true;
  desktopClockX = -1;
  desktopClockY = -1;
  desktopClockWidth = 280;
  desktopClockHeight = 180;
  desktopClockDisplayPreferences = [
    "all"
  ];
  systemMonitorEnabled = false;
  systemMonitorShowHeader = true;
  systemMonitorTransparency = 0.8;
  systemMonitorColorMode = "primary";
  systemMonitorCustomColor = {
    r = 1;
    g = 1;
    b = 1;
    a = 1;
    hsvHue = -1;
    hsvSaturation = 0;
    hsvValue = 1;
    hslHue = -1;
    hslSaturation = 0;
    hslLightness = 1;
    valid = true;
  };
  systemMonitorShowCpu = true;
  systemMonitorShowCpuGraph = true;
  systemMonitorShowCpuTemp = true;
  systemMonitorShowGpuTemp = false;
  systemMonitorGpuPciId = "";
  systemMonitorShowMemory = true;
  systemMonitorShowMemoryGraph = true;
  systemMonitorShowNetwork = true;
  systemMonitorShowNetworkGraph = true;
  systemMonitorShowDisk = true;
  systemMonitorShowTopProcesses = false;
  systemMonitorTopProcessCount = 3;
  systemMonitorTopProcessSortBy = "cpu";
  systemMonitorGraphInterval = 60;
  systemMonitorLayoutMode = "auto";
  systemMonitorX = -1;
  systemMonitorY = -1;
  systemMonitorWidth = 320;
  systemMonitorHeight = 480;
  systemMonitorDisplayPreferences = [
    "all"
  ];
  systemMonitorVariants = [ ];
  desktopWidgetPositions = { };
  desktopWidgetGridSettings = { };
  desktopWidgetInstances = [ ];
  desktopWidgetGroups = [ ];
  builtInPluginSettings = {
    dms_settings_search = {
      trigger = "?";
    };
  };
  clipboardEnterToPaste = false;
  launcherPluginVisibility = { };
  launcherPluginOrder = [ ];
  configVersion = 42;
}
