package com.budapi.control.controllers

import com.budapi.control.firebase.service.BudGroupService
import com.budapi.control.firebase.service.BudService
import com.budapi.control.firebase.service.PlantReferenceService
import com.budapi.control.firebase.service.UserService
import com.budapi.model.Bud
import com.budapi.model.BudWithPlantReference
import com.budapi.util.decodeAndGetPayload
import com.budapi.util.verifyJwtAgainstEmail
import com.budapi.view.jsonResponse
import com.budapi.view.notFound
import com.budapi.view.unauthorized
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestHeader
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

data class BudInputModel(
    var plant_ref: String?,
    var name: String?,
    var ph: Int?,
    var humidity: Int?,
    var luminosity: Int?,
    var temperature: Int?,
    var interior: Boolean?,
    var watering: Boolean?,
)


@RestController
@RequestMapping("bud-api/user/{uid}/group/{group_id}/bud", headers = ["Accept=application/json"])
class BudController(
    val userService: UserService,
    val groupService: BudGroupService,
    val budService: BudService,
    val plantRefService: PlantReferenceService
) {


    @GetMapping("")
    fun getBuds(@PathVariable uid: String, @PathVariable group_id: String, @RequestHeader("Authorization") authorization : String?): ResponseEntity<Any> {

        authorization ?: return unauthorized(
            "Unauthorized Access",
            "No authorization token provided."
        )

        val user = userService.read(uid) ?: return notFound(
            "User not found",
            "Since the user $uid was not found, no bud was found either."
        )

        if(!verifyJwtAgainstEmail(authorization, user.email)) return unauthorized(
            "Unauthorized Access",
            "User email different from the one provided in the token."
        )


        groupService.read(group_id, uid) ?: return notFound(
            "Group not found",
            "Since the bud group $group_id was not found, no bud was found either."
        )
        val buds = budService.readAll(uid, group_id)
        val responseBuds = mutableListOf<BudWithPlantReference>()
        if (buds.isNotEmpty()) {
            buds.forEach() {
                val plantRef = plantRefService.read(it!!.plant_ref)
                responseBuds.add(
                    BudWithPlantReference(
                        it.id,
                        plantRef,
                        it.name,
                        it.ph,
                        it.humidity,
                        it.luminosity,
                        it.temperature,
                        it.interior,
                        it.watering
                    )
                )
            }
            return jsonResponse(responseBuds)
        }
        return jsonResponse(buds)
    }

    @GetMapping("{bud_id}")
    fun getBud(
        @PathVariable uid: String,
        @PathVariable group_id: String,
        @PathVariable bud_id: String,
        @RequestHeader("Authorization") authorization : String?
    ): ResponseEntity<Any> {

        authorization ?: return unauthorized(
            "Unauthorized Access",
            "No authorization token provided."
        )

        val user = userService.read(uid) ?: return notFound(
            "User not found",
            "Since the user $uid was not found, no bud was found either."
        )

        if(!verifyJwtAgainstEmail(authorization, user.email)) return unauthorized(
            "Unauthorized Access",
            "User email different from the one provided in the token."
        )

        groupService.read(group_id, uid) ?: return notFound(
            "Group not found",
            "Since the bud group $group_id was not found, no bud was found either."
        )

        val bud = budService.read(uid, group_id, bud_id) ?: return notFound(
            "Bud not found",
            "Bud with id $bud_id not found"
        )

        val plantReference = plantRefService.read(bud.plant_ref) ?: return notFound(
            "Plant reference in Bud not found",
            "Plant reference with id $bud_id not found"
        )

        return jsonResponse(
            BudWithPlantReference(
                bud.id,
                plantReference,
                bud.name,
                bud.ph,
                bud.humidity,
                bud.luminosity,
                bud.temperature,
                bud.interior,
                bud.watering
            )
        )
    }

    @PostMapping("")
    fun postBud(
        @PathVariable uid: String,
        @PathVariable group_id: String,
        @RequestBody bud: BudInputModel,
        @RequestHeader("Authorization") authorization : String?
    ): ResponseEntity<Any> {

        authorization ?: return unauthorized(
            "Unauthorized Access",
            "No authorization token provided."
        )

        val user = userService.read(uid) ?: return notFound(
            "User not found",
            "Since the user $uid was not found, no bud was found either."
        )

        if(!verifyJwtAgainstEmail(authorization, user.email)) return unauthorized(
            "Unauthorized Access",
            "User email different from the one provided in the token."
        )

        groupService.read(group_id, uid) ?: return notFound(
            "Group not found",
            "Since the group $group_id was not found, no Bud has been created."
        )

        plantRefService.read(bud.plant_ref!!) ?: return notFound(
            "Plant ref not found",
            "No plant reference with the id ${bud.plant_ref} was found."
        )
        val returned_bud = budService.create(
            Bud(
                null,
                bud.plant_ref!!,
                bud.name!!,
                bud.ph?: 0,
                bud.humidity?: 0,
                bud.luminosity?: 0,
                bud.temperature?: 0,
                bud.interior!!,
                false
            ), uid, group_id
        )

        return jsonResponse(returned_bud)
    }


    @PutMapping("/{bud_id}")
    fun putBud(
        @PathVariable uid: String,
        @PathVariable group_id: String,
        @PathVariable bud_id: String,
        @RequestBody bud: BudInputModel,
        @RequestHeader("Authorization") authorization : String?
    ): ResponseEntity<Any> {

        authorization ?: return unauthorized(
            "Unauthorized Access",
            "No authorization token provided."
        )

        val user = userService.read(uid) ?: return notFound(
            "User not found",
            "Since the user $uid was not found, no bud was found either."
        )

        if(!verifyJwtAgainstEmail(authorization, user.email)) return unauthorized(
            "Unauthorized Access",
            "User email different from the one provided in the token."
        )

        groupService.read(group_id, uid) ?: return notFound(
            "Group not found",
            "Since the group $group_id was not found, no Bud has been created."
        )

        val returned_bud = budService.read(uid, group_id, bud_id) ?: return notFound(
            "Bud not found",
            "Couldn't update bud $group_id, make sure it was created before."
        )

        //These checks will prevent any property from updating to null values
        if (bud.plant_ref == null) bud.plant_ref = returned_bud.plant_ref
        if (bud.name == null) bud.name = returned_bud.name
        if (bud.interior == null) bud.interior = returned_bud.interior
        if (bud.luminosity == null) bud.luminosity = returned_bud.luminosity
        if (bud.humidity == null) bud.humidity = returned_bud.humidity
        if (bud.temperature == null) bud.temperature = returned_bud.temperature
        if (bud.ph == null) bud.ph = returned_bud.ph
        if (bud.watering == null) bud.watering = returned_bud.watering

        val updated_bud = budService.update(
            Bud(
                bud_id,
                bud.plant_ref!!,
                bud.name!!,
                bud.ph,
                bud.humidity,
                bud.luminosity,
                bud.temperature,
                bud.interior!!,
                bud.watering!!
            ), uid, group_id
        )
        return jsonResponse(updated_bud)
    }

    @DeleteMapping("/{bud_id}")
    fun deleteGroup(
        @PathVariable uid: String,
        @PathVariable group_id: String,
        @PathVariable bud_id: String,
        @RequestHeader("Authorization") authorization : String?
    ): ResponseEntity<Any> {

        authorization ?: return unauthorized(
            "Unauthorized Access",
            "No authorization token provided."
        )

        val user = userService.read(uid) ?: return notFound(
            "User not found",
            "Since the user $uid was not found, no bud was found either."
        )

        if(!verifyJwtAgainstEmail(authorization, user.email)) return unauthorized(
            "Unauthorized Access",
            "User email different from the one provided in the token."
        )

        val bud = budService.delete(bud_id, group_id, uid) ?: return notFound(
            "about:blank",
            "Bud Doesn't Exist.",
            "This Bud with the id '$bud_id' does not exist in the database."
        )

        return jsonResponse(bud)
    }


}