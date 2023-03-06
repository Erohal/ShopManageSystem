import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Window
import Qt.labs.qmlmodels

Item {
    id: root
    anchors.fill: parent
    property string orderId: ""
    Rectangle {
        anchors.fill: parent
        Rectangle {
            id: header
            width: parent.width
            height: 30
            Row {
                spacing: 0
                width: parent.width
                Repeater {
                    model: ["商品编号", "商品名称", "单件折后价格", "折扣", "进口", "数量"]

                    Rectangle {
                        width: {
                            let w = 0

                            switch (index) {
                            case 0:
                                w = Math.floor(parent.width * 0.1)
                                break
                            case 1:
                                w = Math.floor(parent.width * 0.4)
                                break
                            case 2:
                                w = Math.floor(parent.width * 0.1)
                                break
                            case 3:
                                w = Math.floor(parent.width * 0.1)
                                break
                            case 4:
                                w = Math.floor(parent.width * 0.2)
                                break
                            case 5:
                                w = Math.floor(parent.width * 0.1)
                                break
                            }
                            return w
                        }
                        height: header.height
                        border.width: 1
                        border.color: "#848484"
                        Text {
                            text: modelData
                            anchors.centerIn: parent
                            font.pointSize: 12
                            color: "black"
                        }
                    }
                }
            }
        }

        TableView {
            id: tableView
            width: parent.width
            anchors.top: header.bottom
            anchors.bottom: buttonGroup.top
            anchors.bottomMargin: 10
            clip: true
            boundsBehavior: Flickable.OvershootBounds

            ScrollBar.vertical: ScrollBar {
                anchors.right: parent.right
                anchors.rightMargin: 0
                visible: tableModel.rowCount > 5
                background: Rectangle {
                    color: "white"
                }
                onActiveChanged: {
                    active = true
                }
                contentItem: Rectangle {
                    implicitWidth: 6
                    implicitHeight: 30
                    radius: 3
                    color: "black"
                }
            }

            model: TableModel {
                id: tableModel
                TableModelColumn {
                    display: "id"
                }
                TableModelColumn {
                    display: "name"
                }
                TableModelColumn {
                    display: "price"
                }
                TableModelColumn {
                    display: "cut"
                }
                TableModelColumn {
                    display: "isImportedItem"
                }
                TableModelColumn {
                    display: "num"
                }
            }
            delegate: DelegateChooser {
                DelegateChoice {
                    column: 0
                    delegate: Rectangle {
                        implicitWidth: Math.floor(root.width * 0.1)
                        implicitHeight: 32
                        border.width: 1
                        border.color: "#848484"

                        Text {
                            text: display
                            anchors.centerIn: parent
                            font.pointSize: 12
                            color: "black"
                        }
                    }
                }
                DelegateChoice {
                    column: 1
                    delegate: Rectangle {
                        implicitWidth: Math.floor(root.width * 0.4)
                        implicitHeight: 32
                        border.width: 1
                        border.color: "#848484"
                        clip: true

                        Text {
                            text: display
                            anchors.centerIn: parent
                            font.pointSize: 12
                            color: "black"
                        }
                    }
                }
                DelegateChoice {
                    column: 2
                    delegate: Rectangle {
                        implicitWidth: Math.floor(root.width * 0.1)
                        implicitHeight: 32
                        border.width: 1
                        border.color: "#848484"
                        Text {
                            text: display.toFixed(2)
                            anchors.centerIn: parent
                            font.pointSize: 12
                            color: "black"
                        }
                    }
                }
                DelegateChoice {
                    column: 3
                    delegate: Rectangle {
                        implicitWidth: Math.floor(root.width * 0.1)
                        implicitHeight: 32
                        border.width: 1
                        border.color: "#848484"
                        Text {
                            text: display.toFixed(2)
                            anchors.centerIn: parent
                            font.pointSize: 12
                            color: "black"
                        }
                    }
                }
                DelegateChoice {
                    column: 4
                    delegate: Rectangle {
                        implicitWidth: Math.floor(root.width * 0.2)
                        implicitHeight: 32
                        border.width: 1
                        border.color: "#848484"
                        Text {
                            text: {
                                return display === false ? "否" : "是"
                            }
                            anchors.centerIn: parent
                            font.pointSize: 12
                            color: "black"
                        }
                    }
                }
                DelegateChoice {
                    column: 5
                    delegate: Rectangle {
                        implicitWidth: Math.floor(root.width * 0.1)
                        implicitHeight: 32
                        border.width: 1
                        border.color: "#848484"

                        Text {
                            anchors.centerIn: parent
                            text: display
                        }
                    }
                }
            }
        }
        Rectangle {
            id: buttonGroup
            width: parent.width
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            height: 30
            Label {
                anchors.left: parent.left
                anchors.leftMargin: 10
                id: indecator
                text: {
                    let num = 0
                    let price = 0
                    for (var i = 0; i < tableModel.rowCount; ++i) {
                        let line = tableModel.getRow(i)
                        num += line["num"]
                        price += line["price"] * line["num"]
                    }
                    return `商品数量: ${num}件 总金额: ${price.toFixed(2)}元`
                }
            }
            Button {
                anchors.centerIn: parent
                id: returnBack
                text: "返回"
                onClicked: {
                    stack.pop()
                }
            }
        }
    }
    Component.onCompleted: {
        let json = JSON.parse(model_.getOrderById(orderId))
        for (let itemStack of json["itemStacks"]) {
            tableModel.appendRow({id: itemStack["id"], name: itemStack["name"], price: itemStack["price"] * itemStack["cut"], cut: itemStack["cut"], num: itemStack["num"], isImportedItem: itemStack["isImportedItem"]})
        }
    }
}
