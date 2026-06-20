import QtQuick
import Quickshell
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    property bool sendEnabled: false

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.checkStatus()
    }

    function checkStatus() {
        Proc.runCommand(
            "offlinemsmtp.checkFile",
            ["sh", "-c", "test -f \"$HOME/tmp/offlinemsmtp-sendmail\" && echo 1 || echo 0"],
            function(stdout, exitCode) {
                root.sendEnabled = stdout.trim() === "1"
            },
            100
        )
    }

    function toggle() {
        if (root.sendEnabled) {
            Quickshell.execDetached(["sh", "-c", "rm -f \"$HOME/tmp/offlinemsmtp-sendmail\""])
        } else {
            Quickshell.execDetached(["sh", "-c", "mkdir -p \"$HOME/tmp\" && touch \"$HOME/tmp/offlinemsmtp-sendmail\""])
        }
        root.sendEnabled = !root.sendEnabled
    }

    pillClickAction: () => { root.toggle() }

    horizontalBarPill: Component {
        Item {
            implicitWidth: mailIcon.width
            implicitHeight: mailIcon.height

            DankIcon {
                id: mailIcon
                anchors.centerIn: parent
                name: "send"
                size: Theme.barIconSize(root.barThickness, -4)
                color: root.sendEnabled ? Theme.primary : Theme.surfaceVariantText
            }
        }
    }

    verticalBarPill: Component {
        Item {
            implicitWidth: mailIcon.width
            implicitHeight: mailIcon.height + Theme.spacingM * 2

            DankIcon {
                id: mailIcon
                anchors.centerIn: parent
                name: "send"
                size: Theme.barIconSize(root.barThickness, -4)
                color: root.sendEnabled ? Theme.primary : Theme.surfaceVariantText
            }
        }
    }
}
