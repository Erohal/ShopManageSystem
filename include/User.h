#pragma once

#include "Base.h"
#include "Database.h"
#include "SQLiteCpp/Statement.h"

struct eUser : cBase {
    /** 用户编号 */
    unsigned int id;
    /** 用户账号 */
    std::string username;
    /** 用户密码 */
    std::string password;
    /** 是否为管理员 */
    bool isManager;
    eUser(unsigned int id, const std::string &username, const std::string &password, bool isManager = false)
        : id(id), username(username), password(password), isManager(isManager) {}
    json toJson() const override {
        return json {
            {"id", id},
            {"username", username},
            {"password", password},
            {"isManager", isManager}
        };
    }
};

class cUserManager {
public:
    /** 登录 */
    static unsigned int login(const std::string &username, const std::string &password, bool isManager = false) {
        SQLite::Statement query(cDatabase::getDatabase(), "select id, password, isManager from users where username=?");
        query.bind(1, username);
        if (query.executeStep()) {
            if (query.getColumn("password").getString() == password && query.getColumn("isManager").getInt() == isManager) {
                return query.getColumn("id").getInt();
            }
        }
        return 0;
    }

    /** 注册新用户 */
    static int registe(const std::string &username, const std::string &password, bool isManager = false) {
        if (login(username, password, isManager)) return 0;
        SQLite::Statement query(cDatabase::getDatabase(), "insert into users (username, password, isManager) values (?, ?, ?)");
        query.bind(1, username);
        query.bind(2, password);
        query.bind(3, isManager);
        return query.exec();
    }

    /** 根据用户编号获取用户 */
    static eUser getUserById(unsigned int id) {
        SQLite::Statement query(cDatabase::getDatabase(), "select * from users where id=?");
        query.bind(1, id);
        query.executeStep();
        return eUser(query.getColumn("id").getInt(), query.getColumn("username").getString(), query.getColumn("password").getString(), query.getColumn("isManager").getInt());
    }

    /** 根据用户编号更改用户信息 */
    static int updateUserById(unsigned int id, const std::string &username, const std::string &password, bool isManager = false) {
        SQLite::Statement query(cDatabase::getDatabase(), "update users set username=?, password=?, isManager=? where id=?");
        query.bind(1, username);
        query.bind(2, password);
        query.bind(3, isManager);
        query.bind(4, id);
        return query.exec();
    }

    /** 根据用户编号更改用户信息 */
    static int updateUserById(const eUser &user) {
        SQLite::Statement query(cDatabase::getDatabase(), "update users set username=?, password=?, isManager=? where id=?");
        query.bind(1, user.username);
        query.bind(2, user.password);
        query.bind(3, user.isManager);
        query.bind(4, user.id);
        return query.exec();
    }

    /** 根据用户编号删除用户 */
    static int deleteUserById(unsigned int id) {
        SQLite::Statement query(cDatabase::getDatabase(), "delete from users where id=?");
        query.bind(1, id);
        return query.exec();
    }
};
