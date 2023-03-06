import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material


Item {
    ColumnLayout {
        anchors.fill: parent
        Label {
            id: title
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 50
            text: qsTr("注册到便利店管理系统")
            font.pointSize: 30
        }
        RowLayout {
            id: usernameArea
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: title.bottom
            anchors.topMargin: 30
            Label {
                text: qsTr("账号:")
                font.pointSize: 12
            }
            TextField {
                id: usernameTextField
                placeholderText: "请输入账号"
            }
        }
        RowLayout {
            id: passwordArea
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: usernameArea.bottom
            anchors.topMargin: 10
            Label {
                text: qsTr("密码:")
                font.pointSize: 12
            }
            TextField {
                id: passwordTextField
                placeholderText: "请输入密码"
                echoMode: TextInput.Password
            }
        }
        RowLayout {
            id: passwordAgainArea
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: passwordArea.bottom
            anchors.topMargin: 10
            Label {
                text: qsTr("密码:")
                font.pointSize: 12
            }
            TextField {
                id: passwordAgainTextField
                placeholderText: "请再次输入密码"
                echoMode: TextInput.Password
            }
        }
        RowLayout {
            id: buttonArea
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: passwordAgainArea.bottom
            anchors.topMargin: 10
            Button {
                text: "返回"
                onClicked: {
                    stack.pop()
                }
            }
            Button {
                text: "注册"
                enabled: passwordTextField.text !== "" && passwordTextField.text === passwordAgainTextField.text
                onClicked: {
                    let res = model_.registe(usernameTextField.text, passwordTextField.text);
                    if (res) {
                        showMessageDialog("注册成功！")
                        stack.pop()
                    } else {
                        showMessageDialog("注册失败，已存在相同账户")
                    }
                }
            }
        }
    }
}
