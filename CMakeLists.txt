cmake_minimum_required(VERSION 3.16)

project(ShopManageSystem VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)
set(JSON_BuildTests OFF CACHE INTERNAL "")
set(SQLITECPP_BUILD_EXAMPLES OFF)
set(SQLITECPP_BUILD_TESTS OFF)

find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)

add_subdirectory(thirdparty/SQLiteCpp)
add_subdirectory(thirdparty/json)

aux_source_directory(. SRCS_DIR)
file(GLOB_RECURSE SRC_DIR_LIST "include/*.h")

qt_add_executable(appShopManageSystem
    ${SRCS_DIR} ${SRC_DIR_LIST}
)

qt_add_qml_module(appShopManageSystem
    URI ShopManageSystem
    VERSION 1.0
    QML_FILES main.qml view/LoginView.qml view/RegisteView.qml view/ShopView.qml view/OrderView.qml view/OrderDetailsView.qml view/ShopManageView.qml view/AddNewItemView.qml view/UpdateItemView.qml view/OrderManageView.qml view/StatisticsView.qml
)

set_target_properties(appShopManageSystem PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_include_directories(appShopManageSystem PRIVATE include)
target_link_libraries(appShopManageSystem PRIVATE Qt6::Quick nlohmann_json::nlohmann_json SQLiteCpp sqlite3 pthread ssp)

install(TARGETS appShopManageSystem
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
