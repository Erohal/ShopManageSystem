import QtQuick
import QtQuick.Window
import QtQuick.Dialogs
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material

ApplicationWindow {
    visible: true
    width: 1080
    height: 720
    title: "便利店管理系统"

    Material.theme: Material.Light
    Material.accent: Material.Blue

    property int userId: 0

    function showMessageDialog(message) {
        messageDialog.text = message
        messageDialog.open()
    }

    MessageDialog {
        id: messageDialog
        title: qsTr("提示")
        buttons: MessageDialog.Ok
    }

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: loginView
    }

    Component {
        id: loginView
        LoginView {}
    }

    Component {
        id: registeView
        RegisteView {}
    }

    Component {
        id: shopView
        ShopView {}
    }

    Component {
        id: orderView
        OrderView {}
    }

    Component {
        id: orderDetailsView
        OrderDetailsView {}
    }

    Component {
        id: shopManageView
        ShopManageView {}
    }

    Component {
        id: addNewItemView
        AddNewItemView {}
    }

    Component {
        id: updateItemView
        UpdateItemView {}
    }

    Component {
        id: orderManageView
        OrderManageView {}
    }

    Component {
        id: statisticsView
        StatisticsView {}
    }
}
