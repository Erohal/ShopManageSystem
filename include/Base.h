#pragma once

#include <nlohmann/json.hpp>
using nlohmann::json;

struct cBase {
    virtual json toJson() const = 0;
    
    std::string toString() const {
        return this->toJson().dump();
    }

    friend std::ostream &operator<<(std::ostream &os, const cBase &base) {
        os << base.toJson().dump(4);
        return os;
    }
};