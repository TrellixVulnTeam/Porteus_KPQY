/*
 *  Copyright 2015 David Rosca <nowrep@gmail.com>
 *
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License as
 *  published by the Free Software Foundation; either version 2 of
 *  the License or (at your option) version 3 or any later version
 *  accepted by the membership of KDE e.V. (or its successor approved
 *  by the membership of KDE e.V.), which shall act as a proxy
 *  defined in Section 14 of version 3 of the license.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>
 */

import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5 as QQC2

import org.kde.kirigami 2.8 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore

Kirigami.FormLayout {

    anchors.right: parent.right
    anchors.left: parent.left

    readonly property bool vertical: plasmoid.formFactor == PlasmaCore.Types.Vertical || (plasmoid.formFactor == PlasmaCore.Types.Planar && plasmoid.height > plasmoid.width)

    property alias cfg_maxSectionCount: maxSectionCount.value
    property alias cfg_showLauncherNames: showLauncherNames.checked
    property alias cfg_enablePopup: enablePopup.checked
    property alias cfg_title: title.text


    QQC2.SpinBox {
        id: maxSectionCount

        Kirigami.FormData.label: vertical ? i18nc("@label:spinbox", "Maximum columns:") : i18nc("@label:spinbox", "Maximum rows:")

        from: 1
    }


    Item {
        Kirigami.FormData.isSection: true
    }


    QQC2.CheckBox {
        id: showLauncherNames

        Kirigami.FormData.label: i18nc("@title:group", "Appearance:")

        text: i18nc("@option:check", "Show launcher names")
    }

    QQC2.CheckBox {
        id: enablePopup
        text: i18nc("@option:check", "Enable popup")
    }


    Item {
        Kirigami.FormData.isSection: true
    }


    RowLayout {
        Kirigami.FormData.label: i18nc("@title:group", "Title:")
        Layout.fillWidth: true

        visible: plasmoid.formFactor == PlasmaCore.Types.Planar

        QQC2.CheckBox {
            id: showTitle
            checked: title.length
            text: i18nc("@option:check", "Show:")

            onClicked: {
                if (checked) {
                    title.forceActiveFocus();
                } else {
                    title.text = "";
                }
            }
        }

        Kirigami.ActionTextField {
            id: title
            enabled: showTitle.checked

            Layout.fillWidth: true
            placeholderText: i18nc("@info:placeholder", "Custom title")

            rightActions: [
                Kirigami.Action {
                    iconName: "edit-clear"
                    visible: title.text.length !== 0
                    onTriggered: title.text = "";
                }
            ]
        }
    }
}
