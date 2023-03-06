import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtQuick.Window
import Qt.labs.qmlmodels

Item {
    function getOrder(isMonth, name, time) {
        tableModel.clear()
        let beginTime = time ? time : new Date()
        beginTime.setHours(0)
        beginTime.setMinutes(0)
        beginTime.setSeconds(0)
        beginTime = parseInt(beginTime.getTime() / 1000)
        let endTime = beginTime + 86400
        beginTime -= isMonth ? 86400 * 30 : 0
        console.log(`begin: ${beginTime} end: ${endTime}`)
        let orders = JSON.parse(isMonth || time ? model_.getOrdersBetween(beginTime, endTime) : model_.getOrders())
        for (let order of orders) {
            for (let itemStack of order["itemStacks"]) {
                if (itemStack["name"].search(name) !== -1) {
                    tableModel.appendRow({id: order["id"], userId: order["userId"], createTime: new Date(order["createTime"] * 1000), num: order["num"], price: order["price"], status: order["status"], lookup: undefined})
                    break
                }
            }
        }
    }
    id: root
    anchors.fill: parent
    Material.theme: Material.Light
    Material.accent: Material.Blue
    property alias tableModel: tableModel
    Rectangle {
        anchors.fill: parent
        RowLayout {
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            id: searchItemArea
            Label {
                text: qsTr("商品名称:")
                font.pointSize: 12
            }
            TextField {
                id: searchItemTextField
                placeholderText: qsTr("请输入要搜索的商品的名称")
                onTextChanged: {
                    getOrder(isMonthCheckBox, searchItemTextField.text)
                }
            }
            Label {
                text: qsTr("具体时间:")
                font.pointSize: 12
            }
            TextField {
                id: searchTimeTextField
                placeholderText: qsTr("2022-12-08")
                onTextChanged: {
                    // TODO
                    if (searchTimeTextField.text === "") {
                        color = "black"
                        getOrder(isMonthCheckBox, searchItemTextField.text)
                    } else {
                        const pattern = /^(\d{4})-(\d{2})-(\d{2})$/
                        if (pattern.test(searchTimeTextField.text)) {
                            color = "black"
                            const time = pattern.exec(searchTimeTextField.text)
                            const date = new Date(time[1], parseInt(time[2]) - 1, time[3])
                            console.log(date.toLocaleDateString())
                            getOrder(false, searchItemTextField.text, date)
                            isMonthCheckBox.checked = false
                        } else {
                            color = "red"
                        }
                    }
                }
            }
        }
        Rectangle {
            id: header
            width: parent.width
            anchors.top: searchItemArea.bottom
            height: 30
            Row {
                spacing: 0
                width: parent.width
                Repeater {
                    model: ["订单编号", "用户编号", "创建时间", "商品数量", "价格", "状态", "详细"]

                    Rectangle {
                        width: {
                            let w = 0

                            switch (index) {
                            case 0:
                                w = Math.floor(parent.width * 0.1)
                                break
                            case 1:
                                w = Math.floor(parent.width * 0.1)
                                break
                            case 2:
                                w = Math.floor(parent.width * 0.2)
                                break
                            case 3:
                                w = Math.floor(parent.width * 0.1)
                                break
                            case 4:
                                w = Math.floor(parent.width * 0.2)
                                break
                            case 5:
                                w = Math.floor(parent.width * 0.2)
                                break
                            case 6:
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
                    display: "userId"
                }
                TableModelColumn {
                    display: "createTime"
                }
                TableModelColumn {
                    display: "num"
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
                    column: 2
                    delegate: Rectangle {
                        implicitWidth: Math.floor(root.width * 0.2)
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
                    column: 3
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
                    column: 4
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
                    column: 5
                    delegate: Rectangle {
                        implicitWidth: Math.floor(root.width * 0.2)
                        implicitHeight: 32
                        border.width: 1
                        border.color: "#848484"
                        ComboBox {
                            model: ["已取消", "准备中", "已完成"]
                            currentIndex: display
                            anchors.centerIn: parent
                            onCurrentIndexChanged: {
                                let line = tableModel.getRow(row)
                                model_.updateOrder(line["id"], currentIndex)
                            }
                        }
                    }
                }
                DelegateChoice {
                    column: 6
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
    CheckBox {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        id: isMonthCheckBox
        checked: false
        text: "查看当月订单"
        onCheckedChanged: {
            getOrder(checked, searchItemTextField.text)
        }
    }
    Component.onCompleted: {
        getOrder(false)
    }
}
