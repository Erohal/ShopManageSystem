import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtQuick.Window
import Qt.labs.qmlmodels

Item {
    id: root
    anchors.fill: parent
    Material.theme: Material.Light
    Material.accent: Material.Blue
    property alias tableModel: tableModel
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
                    model: ["订单编号", "创建时间", "价格", "状态", "详细"]

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
                                w = Math.floor(parent.width * 0.2)
                                break
                            case 3:
                                w = Math.floor(parent.width * 0.2)
                                break
                            case 4:
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
            anchors.bottom: buttonGroup.bottom
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
                    display: "createTime"
                }
                TableModelColumn {
                    display: "price"
                }
                TableModelColumn {
                    display: "status"
                }
                TableModelColumn {
                    display: "lookup"
                }
            }
            delegate: DelegateChooser {

                DelegateChoice {
                    column: 0
                    delegate: Rectangle {
                        implicitWidth: Math.floor(root.width * 0.1)
                        implicitHeight: 40
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
                        implicitWidth: Math.floor(root.width * 0.2)
                        implicitHeight: 32
                        border.width: 1
                        border.color: "#848484"
                        clip: true

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
                        implicitWidth: Math.floor(root.width * 0.2)
                        implicitHeight: 32
                        border.width: 1
                        border.color: "#848484"
                        Text {
                            text: {
                                if (display === 0) {
                                    return "已取消"
                                }
                                if (display === 1) {
                                    return "准备中"
                                }
                                if (display === 2) {
                                    return "已成功"
                                }
                            }
                            anchors.centerIn: parent
                            font.pointSize: 12
                            color: "black"
                        }
                    }
                }
                DelegateChoice {
                    column: 4
                    delegate: Rectangle {
                        implicitWidth: Math.floor(root.width * 0.1)
                        implicitHeight: 32
                        border.width: 1
                        border.color: "#848484"
                        RoundButton {
                            anchors.centerIn: parent
                            text: "查看"
                            onClicked: {
                                stack.push(orderDetailsView, {"orderId": tableModel.getRow(row)["id"]})
                            }
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
        let orders = JSON.parse(model_.getOrdersByUserId(userId))
        for (let order of orders) {
            tableModel.appendRow({id: order["id"], createTime: new Date(order["createTime"] * 1000), price: order["price"], status: order["status"], lookup: undefined})
        }
    }
}
