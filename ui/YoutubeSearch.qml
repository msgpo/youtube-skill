/*
 *  Copyright 2018 by Aditya Mehra <aix.m@outlook.com>
 *  Copyright 2018 Marco Martin <mart@kde.org>
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.

 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.9
import QtQuick.Layouts 1.4
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2
import org.kde.kirigami 2.8 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import Mycroft 1.0 as Mycroft

Mycroft.Delegate {
    id: delegate

    property var videoListModel: sessionData.videoListBlob.videoList
    property var recentPlayedModel: sessionData.recentListBlob.recentList
    property var currentSongUrl: sessionData.currenturl
    property var currenttitle: sessionData.currenttitle
    property Component highlighter: PlasmaComponents.Highlight{}
    property Component emptyHighlighter: Item{}

    skillBackgroundSource: "https://source.unsplash.com/weekly?music"
    
    onRecentPlayedModelChanged: {
        console.log(JSON.stringify(recentPlayedModel))
        recentPlayedView.forceLayout()
    }

    Keys.onBackPressed: {
        parent.parent.parent.currentIndex--
        parent.parent.parent.currentItem.contentItem.forceActiveFocus()
    }
    
    ColumnLayout {
        id: recentlyPlayerColumn
        anchors.fill: parent
        spacing: Kirigami.Units.smallSpacing
        
        RowLayout {
            id: headrRecentPlayed
            Layout.fillWidth: true
            Kirigami.Heading {
                id: recentItemList
                Layout.alignment: Qt.AlignLeft
                Layout.fillWidth: true
                text: "Recently Played"
                level: 3
            }
            
            Button {
                id: clearRecentListBtn
                Layout.alignment: Qt.AlignRight
                Layout.preferredWidth: Kirigami.Units.iconSizes.medium
                Layout.preferredHeight: Kirigami.Units.iconSizes.medium
                KeyNavigation.up: closeButton
                
                background: Rectangle {
                    anchors.fill: parent
                    color: clearRecentListBtn.activeFocus ? Kirigami.Theme.highlightColor: Kirigami.Theme.backgroundColor
                }
                
                onClicked: {
                    triggerGuiEvent("YoutubeSkill.ClearDB", {})
                }
                
                Keys.onReturnPressed: {
                    clicked()
                }
                
                contentItem: Item {
                    Kirigami.Icon {
                        anchors.centerIn: parent
                        width: Kirigami.Units.iconSizes.smallMedium
                        height: Kirigami.Units.iconSizes.smallMedium
                        source: "edit-clear-all"
                    }
                }
            }
        }
        
        Kirigami.Separator {
            id: sept1
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            z: 100
        }
        
        ListView {
            id: recentPlayedView
            keyNavigationEnabled: true
            highlight: focus ? highlighter : emptyHighlighter
            model: recentPlayedModel
            interactive: true
            Layout.fillWidth: true
            focus: true
            Layout.fillHeight: true
            spacing: Kirigami.Units.largeSpacing
            currentIndex: 0
            clip: true
            highlightRangeMode: ListView.StrictlyEnforceRange
            snapMode: ListView.SnapToItem
            delegate: Control {
                width: parent.width
                height: Kirigami.Units.gridUnit * 4
                
                background: PlasmaCore.FrameSvgItem {
                id: frame
                anchors {
                    fill: parent
                }
                imagePath: "widgets/background"
                
                width: parent.width
                height: parent.height
                opacity: 0.9
                }

                contentItem: Item {
                    width: parent.width
                    height: parent.height

                    RowLayout {
                        id: delegateItem
                        anchors.fill: parent
                        anchors.margins: Kirigami.Units.smallSpacing
                        spacing: Kirigami.Units.largeSpacing

                        Image {
                            id: videoImage
                            source: modelData.videoImage
                            Layout.preferredHeight: parent.height
                            Layout.preferredWidth: Kirigami.Units.gridUnit * 4
                            Layout.alignment: Qt.AlignHCenter
                            fillMode: Image.Stretch
                        }

                        Label {
                            id: videoLabel
                            Layout.fillWidth: true
                            text: modelData.videoTitle
                            wrapMode: Text.WordWrap
                        }
                    }
                }
                
                Keys.onReturnPressed: {
                    Mycroft.MycroftController.sendRequest("aiix.youtube-skill.playvideo_id", {vidID: modelData.videoID, vidTitle: modelData.videoTitle})
                }
            }
            
            KeyNavigation.up: clearRecentListBtn
            KeyNavigation.down: leftSearchView
        }
        
                
        Kirigami.Heading {
            id: watchItemList
            text: "Watch More.."
            level: 3
        }
        
        Kirigami.Separator {
            id: sept2
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            z: 100
        }
        
        ListView {
            id: leftSearchView
            keyNavigationEnabled: true
            ///highlightFollowsCurrentItem: true
            highlight: focus ? highlighter : emptyHighlighter
            model: videoListModel
            focus: false
            interactive: true
            bottomMargin: delegate.controlBarItem.height + Kirigami.Units.largeSpacing
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Kirigami.Units.largeSpacing
            currentIndex: 0
            highlightRangeMode: ListView.StrictlyEnforceRange
            snapMode: ListView.SnapToItem
            
            delegate: Control {
                width: parent.width
                height: Kirigami.Units.gridUnit * 4
                
                background: PlasmaCore.FrameSvgItem {
                id: frame
                anchors {
                    fill: parent
                }
                imagePath: "widgets/background"
                
                width: parent.width
                height: parent.height
                opacity: 0.9
                }

                
                contentItem: Item {
                    width: parent.width
                    height: parent.height

                    RowLayout {
                        id: delegateItem
                        anchors.fill: parent
                        anchors.margins: Kirigami.Units.smallSpacing
                        spacing: Kirigami.Units.largeSpacing

                        Image {
                            id: videoImage
                            source: modelData.videoImage
                            Layout.preferredHeight: parent.height
                            Layout.preferredWidth: Kirigami.Units.gridUnit * 4
                            Layout.alignment: Qt.AlignHCenter
                            fillMode: Image.Stretch
                        }

                        Label {
                            id: videoLabel
                            Layout.fillWidth: true
                            text: modelData.videoTitle
                            wrapMode: Text.WordWrap
                        }
                    }
                }
                             
                Keys.onReturnPressed: {
                    Mycroft.MycroftController.sendRequest("aiix.youtube-skill.playvideo_id", {vidID: modelData.videoID, vidTitle: modelData.videoTitle})
                }
            }
        }
            KeyNavigation.up: recentPlayedView
    }
    
    Component.onCompleted: {
        recentPlayedView.forceActiveFocus()
    }
}

