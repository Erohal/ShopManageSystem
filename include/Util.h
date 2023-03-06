#pragma once

#include <nlohmann/json.hpp>
using nlohmann::json;

template <typename T>
inline json toJson(const std::vector<T> t) {
    auto data = json::array();
    for (const auto & it : t) {
        data.push_back(it.toJson());
    }
    return data;
}
