import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

Item {
    id: root
    ColumnLayout {
        anchors.fill: parent
        Label {
            id: title
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 50
            text: qsTr("添加新商品")
            font.pointSize: 30
        }
        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: title.bottom
            anchors.margins: 30
            id: itemNameArea
            Label {
                text: qsTr("商品名称：")
                font.pointSize: 12
            }
            TextField {
                id: itemNameTextField
                placeholderText: qsTr("请输入商品名称")
            }
        }
        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: itemNameArea.bottom
            anchors.margins: 10
            id: priceArea
            Label {
                text: qsTr("商品价格：")
                font.pointSize: 12
            }
            TextField {
                id: priceTextField
                placeholderText: qsTr("请输入价格")
            }
        }
        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: priceArea.bottom
            anchors.margins: 10
            id: cutArea
            Label {
                text: qsTr("商品折扣：")
                font.pointSize: 12
            }
            TextField {
                id: cutTextField
                text: "1"
                placeholderText: qsTr("请输入折扣")
            }
        }
        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: cutArea.bottom
            anchors.margins: 10
            id: isImportedItemArea
            Label {
                text: qsTr("是否进口商品：")
                font.pointSize: 12
            }
            CheckBox {
                id: isImportedItemCheckBox
                checked: false
            }
        }
        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: isImportedItemArea.bottom
            anchors.margins: 10
            Button {
                text: qsTr("返回")
                onClicked: {
                    stack.replace(shopManageView)
                }
            }
            Button {
                id: registerButton
                text: qsTr("添加")
                enabled: itemNameTextField.text !== "" && priceTextField.text !== "" && cutTextField.text
                onClicked: {
                    model_.insertItem(JSON.stringify({name: itemNameTextField.text, price: parseFloat(priceTextField.text), cut: parseFloat(cutTextField.text), isImportedItem: isImportedItemCheckBox.checked}))
                    showMessageDialog("添加成功！")
                    stack.replace(shopManageView)
                }
            }
        }

    }
}
