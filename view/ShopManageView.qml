import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Window
import Qt.labs.qmlmodels

Item {
    id: root
    anchors.fill: parent
    function getItems(name) {
        tableModel.clear()
        let items = JSON.parse(name === "" || name === undefined ? model_.getItems() : model_.getItemsByName(name))
        for (let item of items) {
            item["checked"] = false
            item["operate"] = null
            console.log(JSON.stringify(item))
            tableModel.appendRow(item)
        }
    }
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
                    getItems(searchItemTextField.text)
                }
            }
        }
        Rectangle {
            id: header
            anchors.top: searchItemArea.bottom
            width: parent.width
            height: 30
            Row {
                spacing: 0
                width: parent.width
                Repeater {
                    model: ["选择", "商品编号", "商品名称", "商品价格", "商品折扣", "进口", "操作"]
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
                                w = Math.floor(parent.width * 0.1)
                                break
                            case 3:
                                w = Math.floor(parent.width * 0.2)
                                break
                            case 4:
                                w = Math.floor(parent.width * 0.1)
                                break
                            case 5:
                                w = Math.floor(parent.width * 0.2)
                                break
                            case 6:
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
                    display: "checked"
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
                TableModelColumn {
                    display: "operate"
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

                        CheckBox {
                            anchors.centerIn: parent
                            checked: model.display
                            onClicked: {
                                let line = tableModel.getRow(row)
                                line["checked"] = checked
                                tableModel.setRow(row, line)
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
                    column: 5
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
                    column: 6
                    delegate: Rectangle {
                        implicitWidth: Math.floor(root.width * 0.2)
                        implicitHeight: 32
                        border.width: 1
                        border.color: "#848484"
                        RowLayout {
                            anchors.centerIn: parent
                            Button {
                                Layout.preferredHeight: 30
                                text: "修改"
                                onClicked: {
                                    let line = tableModel.getRow(row)
                                    stack.replace(updateItemView, {
                                          id: line["id"],
                                          name: line["name"],
                                          price: line["price"],
                                          cutd: line["cut"],
                                          isImportedItem: line["isImportedItem"]
                                    })
                                }
                            }
                            Button {
                                Layout.preferredHeight: 30
                                text: "删除"
                                onClicked: {
                                    model_.deleteItem(tableModel.getRow(row)["id"])
                                    tableModel.removeRow(row)
                                }
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
            RowLayout {
                anchors.centerIn: parent
                Button {
                    id: deleteButton
                    text: "删除"
                    onClicked: {
                        let num = 0
                        for (let i = tableModel.rowCount - 1; i >= 0; --i) {
                            let line = tableModel.getRow(i)
                            if (line["checked"]) {
                                model_.deleteItem(tableModel.getRow(i)["id"])
                                tableModel.removeRow(i)
                                ++num
                            }
                        }
                        if (!num) {
                            showMessageDialog("您未选择任何商品！")
                        } else {
                            showMessageDialog(`成功删除${num}件商品！`)
                        }
                    }
                }
                Button {
                    id: addNewItem
                    text: "添加商品"
                    onClicked: {
                        stack.replace(addNewItemView)
                    }
                }
                Button {
                    id: lookupOrder
                    text: "管理订单"
                    onClicked: {
                        stack.push(orderManageView)
                    }
                }
                Button {
                    id: lookupStatistics
                    text: "商品统计"
                    onClicked: {
                        stack.push(statisticsView)
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
