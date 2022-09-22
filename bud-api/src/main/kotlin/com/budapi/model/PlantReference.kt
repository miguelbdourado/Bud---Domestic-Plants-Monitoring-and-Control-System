package com.budapi.model

data class PlantReference(
    var id: String?,
    val name: String,
    val temperature_min: Int,
    val temperature_max: Int,
    val ph_min: Int,
    val ph_max: Int,
    val luminosity_min: Int,
    val luminosity_max: Int,
    val humidity_min: Int,
    val humidity_max: Int,
) {
    constructor() : this("", "", 0, 0, 0,
        0, 0, 0, 0, 0)
}
