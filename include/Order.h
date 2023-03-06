#pragma once

#include <ctime>
#include <vector>

#include "Base.h"
#include "Item.h"
#include "Util.h"

struct eOrder : cBase {
    /** 订单编号 */
    unsigned int id;
    /** 订单所属人编号 */
    unsigned int userId;
    /** 创建时间 */
    long createTime;
    /** 商品列表 */
    std::vector<cItemStack> itemStacks;
    /** 商品总件数 */
    unsigned int num = 0;
    /** 订单总价格 */
    float price = 0.0f;
    /** 订单状态 */
    enum class Status {
        CANCLED, /** 已取消 */
        PREPARE, /** 准备中 */
        SUCCESS, /** 已完成*/
    } status;
    
    eOrder(unsigned int id, unsigned int userId, unsigned long createTime, Status status, const std::vector<cItemStack> &itemStacks)
        : id(id), userId(userId), createTime(createTime), status(status), itemStacks(itemStacks) {
        for (const auto &itemStack : itemStacks) {
            num += itemStack.num;
            price += itemStack.cut * itemStack.price * itemStack.num;
        }
    }
    
    /** 是否包含某商品 */
    bool contains(const std::string &name) {
        for (const auto &itemStack : itemStacks) {
            if (itemStack.name.find(name) != itemStack.name.npos) {
                return true;
            }
        }
        return false;
    }

    json toJson() const override {
        auto data = json {
            {"id", id},
            {"userId", userId},
            {"createTime", createTime},
            {"status", status},
            {"itemStacks", json::array()},
            {"num", num},
            {"price", price}
        };
        for (const auto &itemStack : itemStacks) {
            data["itemStacks"].push_back(itemStack.toJson());
        }
        return data;
    }
};

class cOrderManager {
public:
    /** 通过订单编号获取订单 */
    static eOrder getOrderById(unsigned int id) {
        SQLite::Statement query(cDatabase::getDatabase(), "select * from orders where id=?");
        query.bind(1, id);
        query.executeStep();
        std::vector<cItemStack> itemStacks;
        for (const auto &itemStack : json::parse(query.getColumn("itemStacks").getString())) {
            itemStacks.emplace_back(itemStack["id"], itemStack["name"], itemStack["price"], itemStack["cut"], itemStack["isImportedItem"], itemStack["num"]);
        }
        return eOrder(query.getColumn("id").getInt(), query.getColumn("userId").getInt(), query.getColumn("createTime").getInt64(), eOrder::Status(query.getColumn("status").getInt()), itemStacks);
    }

    /** 通过用户编号获取所有订单 */
    static std::vector<eOrder> getOrderByUserId(unsigned int userId) {
        SQLite::Statement query(cDatabase::getDatabase(), "select * from orders where userId=?");
        query.bind(1, userId);
        std::vector<eOrder> orders;
        while (query.executeStep()) {
            std::vector<cItemStack> itemStacks;
            for (const auto &itemStack : json::parse(query.getColumn("itemStacks").getString())) {
                itemStacks.emplace_back(itemStack["id"], itemStack["name"], itemStack["price"], itemStack["cut"], itemStack["isImportedItem"], itemStack["num"]);
            }
            orders.emplace_back(query.getColumn("id").getInt(), query.getColumn("userId").getInt(), query.getColumn("createTime").getInt64(), eOrder::Status(query.getColumn("status").getInt()), itemStacks);
        }
        return orders;
    }

    /** 获取所有订单 */
    static std::vector<eOrder> getOrders() {
        SQLite::Statement query(cDatabase::getDatabase(), "select * from orders");
        std::vector<eOrder> orders;
        while (query.executeStep()) {
            std::vector<cItemStack> itemStacks;
            for (const auto &itemStack : json::parse(query.getColumn("itemStacks").getString())) {
                itemStacks.emplace_back(itemStack["id"], itemStack["name"], itemStack["price"], itemStack["cut"], itemStack["isImportedItem"], itemStack["num"]);
            }
            orders.emplace_back(query.getColumn("id").getInt(), query.getColumn("userId").getInt(), query.getColumn("createTime").getInt64(), eOrder::Status(query.getColumn("status").getInt()), itemStacks);
        }
        return orders;
    }

    /** 获取某段时间内的订单 */
    static std::vector<eOrder> getOrdersBetween(unsigned int beginTime, unsigned int endTime) {
        SQLite::Statement query(cDatabase::getDatabase(), "select * from orders where createTime >= ? and createTime <= ?");
        query.bind(1, beginTime);
        query.bind(2, endTime);
        std::vector<eOrder> orders;
        while (query.executeStep()) {
            std::vector<cItemStack> itemStacks;
            for (const auto &itemStack : json::parse(query.getColumn("itemStacks").getString())) {
                itemStacks.emplace_back(itemStack["id"], itemStack["name"], itemStack["price"], itemStack["cut"], itemStack["isImportedItem"], itemStack["num"]);
            }
            orders.emplace_back(query.getColumn("id").getInt(), query.getColumn("userId").getInt(), query.getColumn("createTime").getInt64(), eOrder::Status(query.getColumn("status").getInt()), itemStacks);
        }
        return orders;
    }


    /** 添加订单 */
    static int insertOrder(unsigned int userId, eOrder::Status status, const std::vector<cItemStack> &itemStacks) {
        SQLite::Statement query(cDatabase::getDatabase(), "insert into orders (userId, createTime, status, itemStacks) values (?, ?, ?, ?)");
        query.bind(1, userId);
        query.bind(2, std::time(nullptr));
        query.bind(3, static_cast<int>(status));
        query.bind(4, toJson(itemStacks).dump());
        return query.exec();
    }

    /** 修改订单状态 */
    static int updateOrder(unsigned int id, eOrder::Status status) {
        SQLite::Statement query(cDatabase::getDatabase(), "update orders set status=? where id=?");
        query.bind(1, static_cast<int>(status));
        query.bind(2, id);
        return query.exec();
    }
};
