#pragma once

#include "SQLiteCpp/Database.h"
#include "SQLiteCpp/Statement.h"
#include <iostream>
#include <string>

class cDatabase {
private:
    inline static SQLite::Database *database = nullptr;
public:
    static void initDb(const std::string &dbName) {
        database = new SQLite::Database(dbName, SQLite::OPEN_READWRITE | SQLite::OPEN_CREATE);
        /** 商品表 */
        database->exec("create table if not exists items " \
            "(" \
            "id integer primary key autoincrement," \
            "name varchar(30) not null," \
            "price real not null," \
            "cut real not null," \
            "isImportedItem integer not null" \
            ")"
        );
        /** 订单表 */
        database->exec("create table if not exists orders " \
            "(" \
            "id integer primary key autoincrement," \
            "userId integer not null," \
            "itemStacks TEXT not null," \
            "createTime integer not null," \
            "status integer not null" \
            ")"
        );
        /** 用户表 */
        database->exec("create table if not exists users " \
            "(" \
            "id integer primary key autoincrement," \
            "username varchar(30) not null," \
            "password varchar(30) not null,"
            "isManager integer not null" \
            ")"
        );
    }

    static SQLite::Database &getDatabase() {
        return *database;
    }
};