import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Window
import Qt.labs.qmlmodels

Item {
    id: root
    anchors.fill: parent
    function getItems() {
        tableModel.clear()
        let items = JSON.parse(model_.getItems())
        for (let item of items) {
            item["num"] = 0
            item["price"] *= item["cut"]
            tableModel.appendRow(item)
        }
    }
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
                    model: ["数量", "商品编号", "商品名称", "折后价格", "折扣", "进口"]
                    Rectangle {
                        width: {
                            let w = 0

                            switch (index) {
                            case 0:
                                w = Math.floor(parent.width * 0.2)
                                break
                            case 1:
                                w = Math.floor(parent.width * 0.1)
                                break
                            case 2:
                                w = Math.floor(parent.width * 0.2)
                                break
                            case 3:
                                w = Math.floor(parent.width * 0.2)
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
                    display: "num"
                }
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
            }
            delegate: DelegateChooser {

                DelegateChoice {
                    column: 0
                    delegate: Rectangle {
                        implicitWidth: Math.floor(root.width * 0.2)
                        implicitHeight: 32
                        border.width: 1
                        border.color: "#848484"

                        SpinBox {
                            anchors.centerIn: parent
                            onValueChanged: {
                                let curRow = tableModel.getRow(row)
                                curRow["num"] = value
                                tableModel.setRow(row, curRow)
                                let num = 0, price = 0
                                for (var i = 0; i < tableModel.rowCount; ++i) {
                                    let line = tableModel.getRow(i)
                                    num += line["num"]
                                    price += line["price"] * line["num"] * line["cut"]
                                }
                                indecator.text = `商品数量: ${num}件 总金额: ${price.toFixed(2)}元`
                            }
                        }
                    }
                }

                DelegateChoice {
                    column: 1
                    delegate: Rectangle {
                        implicitWidth: Math.floor(root.width * 0.1)
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
                            text: display.toFixed(2)
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
                            text: {
                                return display === false ? "否" : "是"
                            }

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
            RowLayout {
                anchors.centerIn: parent
                Button {
                    id: buyButton
                    text: "结算"
                    onClicked: {
                        let json = {userId, itemStacks: []}
                        for (let i = 0; i < tableModel.rowCount; ++i) {
                            let line = tableModel.getRow(i)
                            if (line["num"] !== 0) {
                                json["itemStacks"].push({id: line["id"], num: line["num"]})
                            }
                        }
                        if(json["itemStacks"].length !== 0) {
                            let res = model_.insertOrder(JSON.stringify(json))
                            if (res) {
                                showMessageDialog("下单成功！")
                                stack.push(orderDetailsView, {"orderId": res})
                            } else {
                                showMessageDialog("下单失败！")
                            }
                        } else {
                            showMessageDialog("您未选择任何商品！")
                        }
                    }
                }
                Button {
                    id: lookupOrder
                    text: "查看全部订单"
                    onClicked: {
                        stack.push(orderView)
                    }
                }
                Button {
                    text: "退出系统"
                    onClicked: {
                        stack.replace(loginView)
                    }
                }
            }
        }
    }
    Component.onCompleted: {
        getItems()
    }
}
