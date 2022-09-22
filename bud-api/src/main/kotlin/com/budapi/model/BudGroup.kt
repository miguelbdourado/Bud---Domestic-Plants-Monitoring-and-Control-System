package com.budapi.model

import java.util.*

data class BudGroup(
    val name: String,
    val created_date: Date?,
    var group_id: String? = null,
){
    constructor(): this( "", null, null)
}
