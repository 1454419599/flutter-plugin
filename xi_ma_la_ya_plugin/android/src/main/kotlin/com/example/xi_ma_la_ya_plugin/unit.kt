package com.example.xi_ma_la_ya_plugin

fun value2Long(value: Any?, defaultInt: Long = 0L): Long {
    return if (value is Number) value.toLong() else defaultInt
}

fun value2Int(value: Any?, defaultInt: Int = 0): Int {
    print(value)
    return if (value is Int) value else defaultInt
}