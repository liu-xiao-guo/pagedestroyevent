import QtQuick 2.4
import Ubuntu.Components 1.3

MainView {
    id: mainview
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "pagedestroyevent.liu-xiao-guo"

    width: units.gu(60)
    height: units.gu(85)

    property int index: 0

    Component {
        id: page2Component

        Page {
            id: page


            header: PageHeader {
                id: header
                title: "Second Page"
            }

            Column {
                anchors.centerIn: parent
                spacing: units.gu(5)

                Text {
                    text: "Page: " + index
                }

                Button {
                    text: "Close me"
                    onClicked: pageStack.removePages(pageStack.primaryPage);
                }
            }
        }
    }

    AdaptivePageLayout {
        id: pageLayout
        anchors.fill: parent
        primaryPage: Page {
            header: PageHeader {
                title: "Primary Page"
                flickable: listView
            }

            ListView {
                id: listView
                anchors.fill: parent
                model: 10
                delegate: ListItem {
                    Label { text: modelData }
                    onClicked: {
                        mainview.index = index
                        var incubator = pageLayout.addPageToNextColumn(pageLayout.primaryPage, page2Component);
                        if (incubator && incubator.status === Component.Loading) {
                            incubator.onStatusChanged = function(status) {
                                if (status === Component.Ready) {
                                    // connect page's destruction to decrement model
                                    incubator.object.Component.destruction.connect(function() {
                                        console.log("it is destructed! " + index)
                                    });
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
