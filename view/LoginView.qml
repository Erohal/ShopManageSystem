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
            text: qsTr("登录到便利店管理系统")
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
            id: buttonArea
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: passwordArea.bottom
            anchors.topMargin: 10
            Button {
                text: "登录"
                enabled: usernameTextField.text !== "" && passwordTextField.text !== ""
                onClicked: {
                    userId = model_.login(usernameTextField.text, passwordTextField.text, isManager.checked)
                    console.log(`Login: isManager=${isManager.checked} userId=${userId}`)
                    if (!isManager.checked && userId) {
                        showMessageDialog("登陆成功！")
                        stack.replace(shopView)
                    } else if(isManager.checked && userId) {
                        stack.replace(shopManageView)
                    }
                    else {
                        showMessageDialog("账号或密码错误！")
                    }
                }
            }
            Button {
                text: "注册"
                enabled: !isManager.checked
                onClicked: {
                    stack.push(registeView)
                }
            }
        }
        RowLayout {
            id: usertypeArea
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: buttonArea.bottom
            anchors.topMargin: 10
            RadioButton {
                id: isManager
                text: "管理员"
                checked: true
            }
            RadioButton {
                text: "顾客"
            }
        }
    }
}
