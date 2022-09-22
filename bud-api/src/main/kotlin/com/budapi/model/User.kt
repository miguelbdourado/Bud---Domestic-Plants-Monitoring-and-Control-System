package com.budapi.model

data class User(
    val uid: String,
    val name: String,
    val email: String,
    val admin: Boolean,
) {
    constructor(): this("", "", "", false)
}

