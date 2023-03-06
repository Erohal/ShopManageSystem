#pragma once

#include <string>
#include <vector>

#include "Base.h"
#include "Database.h"
#include "SQLiteCpp/Statement.h"

struct eItem : cBase{
    /** 商品编号 */
    unsigned int id;
    /** 商品名称 */
    std::string name;
    /** 原价格 */
    float price;
    /** 售价 */
    float sellPrice;
    /** 折扣 */
    float cut;
    /** 是否进口产品 */
    bool isImportedItem;
    eItem(unsigned int id, const std::string &name, float price, float cut, bool isImportedItem)
        : id(id), name(name), price(price), sellPrice(price * cut), cut(cut), isImportedItem(isImportedItem) {
    }
    json toJson() const override {
        return json {
            {"id", id},
            {"name", name},
            {"price", price},
            {"cut", cut},
            {"isImportedItem", isImportedItem},
        };
    }
};

struct cItemStack : eItem {
    /** 商品数量 */
    unsigned int num;
    cItemStack(unsigned int id, const std::string &name, float price, float cut, bool isImportedItem, unsigned int num)
        : eItem(id, name, price, cut, isImportedItem), num(num) {}

    cItemStack(const eItem &item, unsigned int num)
        : eItem(item), num(num) {}

    json toJson() const override {
        auto data = eItem::toJson();
        data["num"] = num;
        return data;
    }
};

class cItemManager {
public:
    /** 根据商品编号查找商品 */
    static eItem getItemById(unsigned int id) {
        SQLite::Statement query(cDatabase::getDatabase(), "select * from items where id=?");
        query.bind(1, id);
        query.executeStep();
        return eItem(query.getColumn(0).getInt(), query.getColumn(1).getString(), query.getColumn(2).getDouble(), query.getColumn(3).getDouble(), query.getColumn(4).getInt());
    }

    /** 根据商品名称查找商品 */
    static eItem getItemByName(const std::string &name) {
        SQLite::Statement query(cDatabase::getDatabase(), "select * from items where name=?");
        query.bind(1, name);
        query.executeStep();
        return eItem(query.getColumn(0).getInt(), query.getColumn(1).getString(), query.getColumn(2).getDouble(), query.getColumn(3).getDouble(), query.getColumn(4).getInt());
    }

    /** 根据商品名称查找商品 */
    static std::vector<eItem> getItemsByName(const std::string &name) {
        std::vector<eItem> items;
        SQLite::Statement query(cDatabase::getDatabase(), "select * from items where name like ?");
        query.bind(1, "%" + name + "%");
        while (query.executeStep()) {
            items.emplace_back(query.getColumn(0).getInt(), query.getColumn(1).getString(), query.getColumn(2).getDouble(), query.getColumn(3).getDouble(), query.getColumn(4).getInt());
        }
        return items;
    }

    /** 返回数据库中所有的商品 */
    static std::vector<eItem> getItems() {
        std::vector<eItem> items;
        SQLite::Statement query(cDatabase::getDatabase(), "select * from items");
        while (query.executeStep()) {
            items.emplace_back(query.getColumn(0).getInt(), query.getColumn(1).getString(), query.getColumn(2).getDouble(), query.getColumn(3).getDouble(), query.getColumn(4).getInt());
        }
        return items;
    }

    /** 插入商品 */
    static int insertItem(const std::string &name, float price, float cut, bool isImportedItem) {
        SQLite::Statement query(cDatabase::getDatabase(), "insert into items (name, price, cut, isImportedItem) values (?, ?, ?, ?)");
        query.bind(1, name);
        query.bind(2, price);
        query.bind(3, cut);
        query.bind(4, isImportedItem);
        return query.exec();
    }

    /** 根据商品编号修改商品信息 */
    static int updateItem(unsigned int id, const std::string &name, float price, float cut, bool isImportedItem) {
        SQLite::Statement query(cDatabase::getDatabase(), "update items set name=?, price=?, cut=?, isImportedItem=? where id=?");
        query.bind(1, name);
        query.bind(2, price);
        query.bind(3, cut);
        query.bind(4, isImportedItem);
        query.bind(5, id);
        return query.exec();
    }

    /** 根据商品编号修改商品信息 */
    static int updateItem(const eItem &item) {
        SQLite::Statement query(cDatabase::getDatabase(), "update items set name=?, price=?, cut=?, isImportedItem=? where id=?");
        query.bind(1, item.name);
        query.bind(2, item.price);
        query.bind(3, item.cut);
        query.bind(4, item.isImportedItem);
        query.bind(5, item.id);
        return query.exec();
    }

    /** 根据商品编号删除商品 */
    static int deleteItem(unsigned int id) {
        SQLite::Statement query(cDatabase::getDatabase(), "delete from items where id=?");
        query.bind(1, id);
        return query.exec();
    }
};
