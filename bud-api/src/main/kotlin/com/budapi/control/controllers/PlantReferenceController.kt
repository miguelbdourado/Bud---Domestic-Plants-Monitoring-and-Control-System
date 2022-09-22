package com.budapi.control.controllers

import com.budapi.control.firebase.service.PlantReferenceService
import com.budapi.model.PlantReference
import com.budapi.model.User
import com.budapi.view.jsonResponse
import com.budapi.view.notFound
import com.budapi.view.problemResponse
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController


data class PlantReferenceInputModel (
    val id : String?,
    val name : String,
    val temperature_min : Int,
    val temperature_max : Int,
    val ph_min : Int,
    val ph_max : Int,
    val luminosity_min : Int,
    val luminosity_max: Int,
    val humidity_min : Int,
    val humidity_max: Int,
)
@RestController
@RequestMapping("bud-api/plant", headers = ["Accept=application/json"])
class PlantReferenceController(private val plantRefService: PlantReferenceService) {

    @GetMapping("")
    fun getPlants(): ResponseEntity<Any> =jsonResponse(plantRefService.readAll())

    @GetMapping("/{ref_id}")
    fun getPlant(@PathVariable ref_id: String): ResponseEntity<Any> {
        val plant = plantRefService.read(ref_id)

        plant ?: return notFound("Plant reference not found", "The plant reference with id $ref_id was not found")

        return jsonResponse(plant)
    }

    @PostMapping("")
    fun postPlant(@RequestBody plantInputModel: PlantReferenceInputModel): ResponseEntity<Any> {

        val plant = PlantReference(null,
            plantInputModel.name,
            plantInputModel.temperature_min,
            plantInputModel.temperature_max,
            plantInputModel.ph_min,
            plantInputModel.ph_max,
            plantInputModel.luminosity_min,
            plantInputModel.luminosity_max,
            plantInputModel.humidity_min,
            plantInputModel.humidity_max
        )
        plantRefService.create(plant)

        return jsonResponse(plant)
    }

    @PutMapping("/{ref_id}")
    fun putPlant(@PathVariable ref_id: String , @RequestBody plantInputModel: PlantReferenceInputModel): ResponseEntity<Any> {

        plantRefService.read(ref_id) ?: return notFound(
            "Plant Reference not found",
            "Couldn't update plant reference $ref_id, make sure it was created before."
        )

        val plant = PlantReference(ref_id,
            plantInputModel.name,
            plantInputModel.temperature_min,
            plantInputModel.temperature_max,
            plantInputModel.ph_min,
            plantInputModel.ph_max,
            plantInputModel.luminosity_min,
            plantInputModel.luminosity_max,
            plantInputModel.humidity_min,
            plantInputModel.humidity_max
        )
        plantRefService.update(plant)
        return jsonResponse(plant)
    }

    @DeleteMapping("/{ref_id}")
    fun deletePlant(@PathVariable ref_id: String): ResponseEntity<Any> {
        val user = plantRefService.delete(ref_id) ?: return notFound("Plant not found", "The Plant reference with id $ref_id was not found")
        return jsonResponse(user)
    }
}