#pragma once

#include <QObject>

#include "User.h"
#include "Item.h"
#include "Order.h"
#include "Util.h"

class Model : public QObject {
Q_OBJECT
public:
    explicit Model(QObject *parent = nullptr) {};

    /** 登录 */
    Q_INVOKABLE unsigned login(const QString &username, const QString &password, bool isManager = false) {
        return cUserManager::login(username.toStdString(), password.toStdString(), isManager);
    }

    /** 注册 */
    Q_INVOKABLE bool registe(const QString &username, const QString &password, bool isManager = false) {
        return cUserManager::registe(username.toStdString(), password.toStdString(), isManager);
    }

    /** 获取所有商品 */
    Q_INVOKABLE QString getItems() {
        return toJson(cItemManager::getItems()).dump().c_str();
    }

    /** 根据商品编号获取商品 */
    Q_INVOKABLE QString getItemById(unsigned int id) {
        return cItemManager::getItemById(id).toString().c_str();
    }

    /** 根据商品名称模糊查找商品 */
    Q_INVOKABLE QString getItemsByName(const QString &name) {
        return toJson(cItemManager::getItemsByName(name.toStdString())).dump().c_str();
    }

    /** 插入商品 */
    Q_INVOKABLE bool insertItem(const QString &json) {
        auto data = json::parse(json.toStdString());
        return cItemManager::insertItem(data["name"], data["price"], data["cut"], data["isImportedItem"]);
    }

    /** 更新商品 */
    Q_INVOKABLE bool updateItem(const QString &json) {
        auto data = json::parse(json.toStdString());
        return cItemManager::updateItem(data["id"], data["name"], data["price"], data["cut"], data["isImportedItem"]);
    }

    /** 删除商品 */
    Q_INVOKABLE bool deleteItem(unsigned int id) {
        return cItemManager::deleteItem(id);
    }

    /** 根据订单编号获取订单 */
    Q_INVOKABLE QString getOrderById(unsigned int id) {
        return cOrderManager::getOrderById(id).toString().c_str();
    }

    /** 根据用户编号获取所有该用户的订单 */
    Q_INVOKABLE QString getOrdersByUserId(unsigned int id) {
        return toJson(cOrderManager::getOrderByUserId(id)).dump().c_str();
    }

    /** 获取所有订单 */
    Q_INVOKABLE QString getOrders() {
        return toJson(cOrderManager::getOrders()).dump().c_str();
    }

    /** 获取一段时间内的所有订单 */
    Q_INVOKABLE QString getOrdersBetween(unsigned int beginTime, unsigned int endTime) {
        return toJson(cOrderManager::getOrdersBetween(beginTime, endTime)).dump().c_str();
    }

    /** 更新订单状态 */
    Q_INVOKABLE bool updateOrder(unsigned int id, unsigned int status) {
        return cOrderManager::updateOrder(id, eOrder::Status(status));
    }

    /** 添加订单 */
    /**
    * 数据结构
    *  {
    *   "userId": userId
    *   "itemStacks": [{"id": id, "num": num}...]
    *  }
    */
    Q_INVOKABLE unsigned int insertOrder(const QString &json) {
        auto data = json::parse(json.toStdString());
        unsigned int userId = data["userId"];
        std::vector<cItemStack> itemStacks;
        for (const auto &itemStack : data["itemStacks"]) {
            auto item = cItemManager::getItemById(itemStack["id"]);
            itemStacks.emplace_back(cItemStack(item, itemStack["num"]));
        }
        cOrderManager::insertOrder(userId, eOrder::Status::PREPARE, itemStacks);
        return (cOrderManager::getOrderByUserId(userId).cend() - 1)->id;
    }
};
