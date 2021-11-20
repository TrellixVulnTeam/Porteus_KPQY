/*
 *   Copyright 2016 Marco Martin <mart@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.1
import org.kde.kirigami 2.4

Rectangle {
    id: background
    color: listItem.checked || listItem.highlighted || (listItem.supportsMouseEvents && listItem.pressed && !listItem.checked && !listItem.sectionDelegate)
        ? listItem.activeBackgroundColor
        : (listItem.alternatingBackground && index%2 ? listItem.alternateBackgroundColor : listItem.backgroundColor)

    visible: listItem.ListView.view ? listItem.ListView.view.highlight === null : true
    Rectangle {
        id: internal
        property bool indicateActiveFocus: listItem.pressed || Settings.tabletMode || listItem.activeFocus || (listItem.ListView.view ? listItem.ListView.view.activeFocus : false)
        anchors.fill: parent
        visible: !Settings.tabletMode && listItem.supportsMouseEvents
        color: listItem.activeBackgroundColor
        opacity: (listItem.hovered || listItem.highlighted || listItem.activeFocus) && !listItem.pressed ? 0.5 : 0
        Behavior on opacity { NumberAnimation { duration: Units.longDuration } }
    }

    readonly property bool __separatorVisible: listItem.separatorVisible

    Separator {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.top
        }
        visible: background.__separatorVisible
    }

    Separator {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        visible: background.__separatorVisible
    }
}

