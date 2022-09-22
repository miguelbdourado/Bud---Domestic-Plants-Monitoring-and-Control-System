package com.budapi.model

data class Bud(
    var id: String? = null,
    val plant_ref: String,
    val name: String,
    val ph: Int?,
    val humidity: Int?,
    val luminosity: Int?,
    val temperature: Int?,
    val interior: Boolean,
    val watering: Boolean,
){
    constructor(): this( "", "", "", -1, -1, -1, -1, false, false)
}

data class BudWithPlantReference(
    var id: String? = null,
    val plant_ref: PlantReference?,
    val name: String,
    val ph: Int?,
    val humidity: Int?,
    val luminosity: Int?,
    val temperature: Int?,
    val interior: Boolean?,
    val watering: Boolean?,
){
    constructor(): this( "", null, "", -1, -1, -1, -1, false, false)
}