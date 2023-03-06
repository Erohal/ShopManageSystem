import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Window
import Qt.labs.qmlmodels

Item {
    function statisticsItems(isMonth) {
        tableModel.clear()
        let beginTime = new Date()
        beginTime.setHours(0)
        beginTime.setMinutes(0)
        beginTime.setSeconds(0)
        beginTime = parseInt(beginTime.getTime() / 1000)
        let endTime = beginTime + 86400
        beginTime -= isMonth ? 86400 * 30 : 0
        let orders = JSON.parse(model_.getOrdersBetween(beginTime, endTime))
        let items = {}
        for (let order of orders) {
            for (let itemStack of order["itemStacks"]) {
                if (!items[itemStack["id"]]) {
                    items[itemStack["id"]] = {id: itemStack["id"], name: itemStack["name"], num: itemStack["num"], price: itemStack["price"] * itemStack["num"] * itemStack["cut"]}
                } else {
                    items[itemStack["id"]]["num"] += itemStack["num"]
                    items[itemStack["id"]]["price"] += itemStack["price"] * itemStack["cut"] * itemStack["num"]

                }
            }
        }
        let price = 0, num = 0
        for (let key in items) {
            num += items[key]["num"]
            price += items[key]["price"]
            tableModel.appendRow(items[key])
        }
        indecator.text = `商品数量: ${num}件 总金额: ${price.toFixed(2)}元`
    }
    id: root
    anchors.fill: parent
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
                    model: ["商品编号", "商品名称", "销量", "销售额"]
                    Rectangle {
                        width: {
                            let w = 0

                            switch (index) {
                            case 0:
                                w = Math.floor(parent.width * 0.2)
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
                    display: "num"
                }
                TableModelColumn {
                    display: "price"
                }
            }
            delegate: DelegateChooser {
                DelegateChoice {
                    column: 0
                    delegate: Rectangle {
                        implicitWidth: Math.floor(root.width * 0.2)
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
                        implicitWidth: Math.floor(root.width * 0.2)
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
                    column: 3
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
                text: "商品数量: 0件 总金额: 0.00元"
            }
            Button {
                anchors.centerIn: parent
                text: "返回"
                onClicked: {
                    stack.pop()
                }
            }
        }
        CheckBox {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 10
            anchors.bottomMargin: 10
            id: monthCheckBox
            checked: false
            text: "查看当月销售情况"
            onCheckedChanged: {
                statisticsItems(checked)
            }
        }
    }
    Component.onCompleted: {
        statisticsItems(false)
    }
}
