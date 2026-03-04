import QtQuick
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    property bool isRecording: false

    ccWidgetIcon: isRecording ? "videocam" : "videocam_off"
    ccWidgetPrimaryText: "Screen Recorder"
    ccWidgetSecondaryText: isRecording ? "Recording" : "Stopped"
    ccWidgetIsActive: isRecording

    onCcWidgetToggled: {
        if (isRecording) {
            stopRecording.running = true
        } else {
            startRecording.running = true
        }
    }

    Process {
        id: checkStatus
        command: ["systemctl", "--user", "is-active", "gpu-screen-recorder"]
        onExited: (code, status) => {
            root.isRecording = (code === 0)
        }
    }

    Process {
        id: startRecording
        command: ["systemctl", "--user", "start", "gpu-screen-recorder"]
        onExited: {
            checkStatus.running = true
            ToastService.showInfo("Screen Recorder", "Started recording")
        }
    }

    Process {
        id: stopRecording
        command: ["systemctl", "--user", "stop", "gpu-screen-recorder"]
        onExited: {
            checkStatus.running = true
            ToastService.showInfo("Screen Recorder", "Stopped recording")
        }
    }

    Process {
        id: saveReplay
        command: ["sh", "-c", "killall -SIGUSR1 gpu-screen-recorder && notify-send 'Replay Saved' 'Saved to ~/Videos/'"]
        onExited: {
            ToastService.showInfo("Replay Saved", "Saved to ~/Videos/")
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: checkStatus.running = true
    }

    Component.onCompleted: checkStatus.running = true

    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingXS

            DankIcon {
                name: root.isRecording ? "videocam" : "videocam_off"
                color: root.isRecording ? Theme.error : Theme.surfaceVariantText
                size: Theme.iconSize - 4
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (root.isRecording) {
                            stopRecording.running = true
                        } else {
                            startRecording.running = true
                        }
                    }
                }
            }

            DankIcon {
                visible: root.isRecording
                name: "save"
                color: Theme.primary
                size: Theme.iconSize - 4
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: saveReplay.running = true
                }
            }
        }
    }

    verticalBarPill: Component {
        Column {
            spacing: Theme.spacingXS

            DankIcon {
                name: root.isRecording ? "videocam" : "videocam_off"
                color: root.isRecording ? Theme.error : Theme.surfaceVariantText
                size: Theme.iconSize - 4
                anchors.horizontalCenter: parent.horizontalCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (root.isRecording) {
                            stopRecording.running = true
                        } else {
                            startRecording.running = true
                        }
                    }
                }
            }

            DankIcon {
                visible: root.isRecording
                name: "save"
                color: Theme.primary
                size: Theme.iconSize - 4
                anchors.horizontalCenter: parent.horizontalCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: saveReplay.running = true
                }
            }
        }
    }
}
