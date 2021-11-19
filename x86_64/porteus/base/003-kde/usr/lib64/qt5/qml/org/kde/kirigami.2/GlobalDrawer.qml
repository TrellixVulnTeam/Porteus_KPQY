/*
 *   Copyright 2015 Marco Martin <mart@kde.org>
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

import QtQuick 2.6
import QtQuick.Templates 2.0 as T2
import QtQuick.Controls 2.0 as QQC2
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import org.kde.kirigami 2.4

import "private"
import "templates/private"

/**
 * A drawer specialization intended for the global actions of the application
 * valid regardless of the application state (think about the menubar
 * of a desktop application).
 *
 * Example usage:
 * @code
 * import org.kde.kirigami 2.4 as Kirigami
 *
 * Kirigami.ApplicationWindow {
 *  [...]
 *     globalDrawer: Kirigami.GlobalDrawer {
 *         actions: [
 *            Kirigami.Action {
 *                text: "View"
 *                iconName: "view-list-icons"
 *                Kirigami.Action {
 *                        text: "action 1"
 *                }
 *                Kirigami.Action {
 *                        text: "action 2"
 *                }
 *                Kirigami.Action {
 *                        text: "action 3"
 *                }
 *            },
 *            Kirigami.Action {
 *                text: "Sync"
 *                iconName: "folder-sync"
 *            }
 *         ]
 *     }
 *  [...]
 * }
 * @endcode
 *
 */
OverlayDrawer {
    id: root
    edge: Qt.application.layoutDirection == Qt.RightToLeft ? Qt.RightEdge : Qt.LeftEdge

    /**
     * title: string
     * A title to be displayed on top of the drawer
     */
    property alias title: bannerImage.title

    /**
     * icon: var
     * An icon to be displayed alongside the title.
     * It can be a QIcon, a fdo-compatible icon name, or any url understood by Image
     */
    property alias titleIcon: bannerImage.titleIcon

    /**
     * bannerImageSource: string
     * An image to be used as background for the title and icon for
     * a decorative purpose.
     * It accepts any url format supported by Image
     */
    property alias bannerImageSource: bannerImage.source

    /**
     * actions: list<Action>
     * The list of actions can be nested having a tree structure.
     * A tree depth bigger than 2 is discouraged.
     *
     * Example usage:
     * @code
     * import org.kde.kirigami 2.4 as Kirigami
     *
     * Kirigami.ApplicationWindow {
     *  [...]
     *     globalDrawer: Kirigami.GlobalDrawer {
     *         actions: [
     *            Kirigami.Action {
     *                text: "View"
     *                iconName: "view-list-icons"
     *                Kirigami.Action {
     *                        text: "action 1"
     *                }
     *                Kirigami.Action {
     *                        text: "action 2"
     *                }
     *                Kirigami.Action {
     *                        text: "action 3"
     *                }
     *            },
     *            Kirigami.Action {
     *                text: "Sync"
     *                iconName: "folder-sync"
     *            }
     *         ]
     *     }
     *  [...]
     * }
     * @endcode
     */
    property list<QtObject> actions

    /**
     * content: list<Item> default property
     * Any random Item can be instantiated inside the drawer and
     * will be displayed underneath the actions list.
     *
     * Example usage:
     * @code
     * import org.kde.kirigami 2.4 as Kirigami
     *
     * Kirigami.ApplicationWindow {
     *  [...]
     *     globalDrawer: Kirigami.GlobalDrawer {
     *         actions: [...]
     *         Button {
     *             text: "Button"
     *             onClicked: //do stuff
     *         }
     *     }
     *  [...]
     * }
     * @endcode
     */
    default property alias content: mainContent.data

    /**
     * topContent: list<Item> default property
     * Items that will be instantiated inside the drawer and
     * will be displayed on top of the actions list.
     *
     * Example usage:
     * @code
     * import org.kde.kirigami 2.4 as Kirigami
     *
     * Kirigami.ApplicationWindow {
     *  [...]
     *     globalDrawer: Kirigami.GlobalDrawer {
     *         actions: [...]
     *         topContent: [Button {
     *             text: "Button"
     *             onClicked: //do stuff
     *         }]
     *     }
     *  [...]
     * }
     * @endcode
     */
    property alias topContent: topContent.data

    /**
     * showContentWhenCollapsed: bool
     * If true, when the drawer is collapsed as a sidebar, the content items
     * at the bottom will be hidden (default false).
     * If you want to keep some items visible and some invisible, set this to 
     * false and control the visibility/opacity of individual items,
     * binded to the collapsed property
     * @since 2.5
     */
    property bool showContentWhenCollapsed: false

    /**
     * showTopContentWhenCollapsed: bool
     * If true, when the drawer is collapsed as a sidebar, the top content items
     * at the top will be hidden (default false).
     * If you want to keep some items visible and some invisible, set this to 
     * false and control the visibility/opacity of individual items,
     * binded to the collapsed property
     * @since 2.5
     */
    property bool showTopContentWhenCollapsed: false

    /**
     * resetMenuOnTriggered: bool
     *
     * On the actions menu, whenever a leaf action is triggered, the menu
     * will reset to its parent.
     */
    property bool resetMenuOnTriggered: true

    /**
     * currentSubMenu: Action
     *
     * Points to the action acting as a submenu
     */
    readonly property Action currentSubMenu: stackView.currentItem ? stackView.currentItem.current: null

    /**
     * Notifies that the banner has been clicked
     */
    signal bannerClicked()

    /**
     * Reverts the menu back to its initial state
     */
    function resetMenu() {
        stackView.pop(stackView.get(0, T2.StackView.DontLoad));
        if (root.modal) {
            root.drawerOpen = false;
        }
    }

    rightPadding: !Settings.isMobile && mainFlickable.contentHeight > mainFlickable.height ? Units.gridUnit : Units.smallSpacing

    contentItem: ScrollView {
        id: scrollView
        //ensure the attached property exists
        Theme.inherit: true
        anchors.fill: parent
        implicitWidth: Math.min (Units.gridUnit * 20, root.parent.width * 0.8)
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

        Flickable {
            id: mainFlickable
            contentWidth: width
            contentHeight: mainColumn.Layout.minimumHeight
            
            ColumnLayout {
                id: mainColumn
                width: mainFlickable.width
                spacing: 0
                height: Math.max(root.height, Layout.minimumHeight)

                //TODO: cable visible of bannerimage
                Item {
                    implicitHeight: root.collapsible 
                            ? Math.max(collapseButton.height + Units.smallSpacing, bannerImage.Layout.preferredHeight)
                            : bannerImage.Layout.preferredHeight

                    Layout.fillWidth: true
                    visible: !bannerImage.empty || root.collapsible

                    BannerImage {
                        id: bannerImage
                        anchors.fill: parent
                        opacity: !root.collapsed
                        fillMode: Image.PreserveAspectCrop

                        Behavior on opacity {
                            OpacityAnimator {
                                duration: Units.longDuration
                                easing.type: Easing.InOutQuad
                            }
                        }
                        leftPadding: root.collapsible ? collapseButton.width + Units.smallSpacing*2 : topPadding
                        MouseArea {
                            anchors.fill: parent
                            onClicked: root.bannerClicked()
                        }
                        EdgeShadow {
                            edge: Qt.BottomEdge
                            visible: bannerImageSource != ""
                            anchors {
                                left: parent.left
                                right: parent.right
                                bottom: parent.top
                            }
                        }
                    }
                    PrivateActionToolButton {
                        id: collapseButton
                        readonly property bool noTitle: (!root.title || root.title.length===0) && (!root.titleIcon || root.title.length===0)
                        anchors {
                            top: parent.top
                            left: parent.left
                            topMargin: root.collapsed || noTitle ? 0 : Units.smallSpacing + Units.iconSizes.large/2 - height/2
                            leftMargin: root.collapsed || noTitle ? 0 : Units.smallSpacing
                            Behavior on leftMargin {
                                NumberAnimation {
                                    duration: Units.longDuration
                                    easing.type: Easing.InOutQuad
                                }
                            }
                            Behavior on topMargin {
                                NumberAnimation {
                                    duration: Units.longDuration
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }

                        width: Units.iconSizes.smallMedium + Units.largeSpacing * 2
                        height: width

                        Behavior on y {
                            YAnimator {
                                duration: Units.longDuration
                                easing.type: Easing.InOutQuad
                            }
                        }

                        visible: root.collapsible
                        kirigamiAction: Action {
                            icon.name: "application-menu"
                            checkable: true
                            checked: !root.collapsed
                            onCheckedChanged: root.collapsed = !checked
                        }
                    }
                }

                ColumnLayout {
                    id: topContent
                    spacing: 0
                    Layout.alignment: Qt.AlignHCenter
                    Layout.leftMargin: root.leftPadding
                    Layout.rightMargin: root.rightPadding
                    Layout.bottomMargin: Units.smallSpacing
                    Layout.topMargin: root.topPadding
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredHeight: implicitHeight * opacity
                    //NOTE: why this? just Layout.fillWidth: true doesn't seem sufficient
                    //as items are added only after this column creation
                    Layout.minimumWidth: parent.width - root.leftPadding - root.rightPadding
                    visible: children.length > 0 && childrenRect.height > 0 && opacity > 0
                    opacity: !root.collapsed || showTopContentWhenCollapsed
                    Behavior on opacity {
                        //not an animator as is binded
                        NumberAnimation {
                            duration: Units.longDuration
                            easing.type: Easing.InOutQuad
                        }
                    }
                }

                T2.StackView {
                    id: stackView
                    Layout.fillWidth: true
                    Layout.minimumHeight: currentItem ? currentItem.implicitHeight : 0
                    Layout.maximumHeight: Layout.minimumHeight
                    property ActionsMenu openSubMenu
                    initialItem: menuComponent
                    //NOTE: it's important those are NumberAnimation and not XAnimators
                    // as while the animation is running the drawer may close, and
                    //the animator would stop when not drawing see BUG 381576
                    popEnter: Transition {
                        NumberAnimation { property: "x"; from: (stackView.mirrored ? -1 : 1) * -stackView.width; to: 0; duration: 400; easing.type: Easing.OutCubic }
                    }

                    popExit: Transition {
                        NumberAnimation { property: "x"; from: 0; to: (stackView.mirrored ? -1 : 1) * stackView.width; duration: 400; easing.type: Easing.OutCubic }
                    }

                    pushEnter: Transition {
                        NumberAnimation { property: "x"; from: (stackView.mirrored ? -1 : 1) * stackView.width; to: 0; duration: 400; easing.type: Easing.OutCubic }
                    }

                    pushExit: Transition {
                        NumberAnimation { property: "x"; from: 0; to: (stackView.mirrored ? -1 : 1) * -stackView.width; duration: 400; easing.type: Easing.OutCubic }
                    }

                    replaceEnter: Transition {
                        NumberAnimation { property: "x"; from: (stackView.mirrored ? -1 : 1) * stackView.width; to: 0; duration: 400; easing.type: Easing.OutCubic }
                    }

                    replaceExit: Transition {
                        NumberAnimation { property: "x"; from: 0; to: (stackView.mirrored ? -1 : 1) * -stackView.width; duration: 400; easing.type: Easing.OutCubic }
                    }
                }
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: root.actions.length>0
                    Layout.minimumHeight: Units.smallSpacing
                }

                ColumnLayout {
                    id: mainContent
                    Layout.alignment: Qt.AlignHCenter
                    Layout.leftMargin: root.leftPadding
                    Layout.rightMargin: root.rightPadding
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    //NOTE: why this? just Layout.fillWidth: true doesn't seem sufficient
                    //as items are added only after this column creation
                    Layout.minimumWidth: parent.width - root.leftPadding - root.rightPadding
                    visible: children.length > 0 && (opacity > 0 || mainContentAnimator.running)
                    opacity: !root.collapsed || showContentWhenCollapsed
                    Behavior on opacity {
                        OpacityAnimator {
                            id: mainContentAnimator
                            duration: Units.longDuration
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
                Item {
                    Layout.minimumWidth: Units.smallSpacing
                    Layout.minimumHeight: root.bottomPadding
                }

                Component {
                    id: menuComponent

                    Column {
                        spacing: 0
                        property alias model: actionsRepeater.model
                        property Action current

                        property int level: 0
                        Layout.maximumHeight: Layout.minimumHeight

                        move: Transition {
                            YAnimator {
                                duration: Units.longDuration/2
                                easing.type: Easing.InOutQuad
                            }
                        }

                        BasicListItem {
                            id: backItem
                            visible: level > 0
                            supportsMouseEvents: true
                            icon: (LayoutMirroring.enabled ? "go-previous-symbolic-rtl" : "go-previous-symbolic")

                            label: MnemonicData.richTextLabel
                            MnemonicData.enabled: backItem.enabled && backItem.visible
                            MnemonicData.controlType: MnemonicData.MenuItem
                            MnemonicData.label: qsTr("Back")

                            separatorVisible: false
                            onClicked: stackView.pop()
                        }
                        Shortcut {
                            sequence: backItem.MnemonicData.sequence
                            onActivated: backItem.clicked()
                        }

                        Repeater {
                            id: actionsRepeater
                            model: root.actions
                            delegate: Column {
                                width: parent.width
                                GlobalDrawerActionItem {
                                    id: drawerItem
                                    width: parent.width
                                }
                                Repeater {
                                    model: drawerItem.visible && modelData.hasOwnProperty("expandible") && modelData.expandible ? modelData.children : null
                                    delegate: GlobalDrawerActionItem {
                                        width: parent.width
                                        leftPadding: Units.largeSpacing * 2
                                        opacity: !root.collapsed
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

