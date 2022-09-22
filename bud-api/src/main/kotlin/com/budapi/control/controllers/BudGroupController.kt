package com.budapi.control.controllers

import com.budapi.control.firebase.service.BudGroupService
import com.budapi.control.firebase.service.UserService
import com.budapi.model.BudGroup
import com.budapi.util.verifyJwtAgainstEmail
import com.budapi.view.jsonResponse
import com.budapi.view.notFound
import com.budapi.view.problemResponse
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
import java.util.*

data class BudGroupInputModel(
    val name: String,
)

@RestController
@RequestMapping("bud-api/user/{uid}/group", headers = ["Accept=application/json"])
class BudCollectionController(val groupService: BudGroupService, val userService: UserService) {


    @GetMapping("")
    fun getGroups(
        @PathVariable uid: String,
        @RequestHeader("Authorization") authorization: String?
    ): ResponseEntity<Any> {

        authorization ?: return unauthorized(
            "Unauthorized Access",
            "No authorization token provided."
        )

        val user = userService.read(uid) ?: return notFound(
            "User not found",
            "Since the user $uid was not found, no group was found either."
        )

        if(!verifyJwtAgainstEmail(authorization, user.email)) return unauthorized(
            "Unauthorized Access",
            "User email different from the one provided in the token."
        )

        return jsonResponse(groupService.readAll(uid))
    }

    @GetMapping("/{group_id}")
    fun getGroup(
        @PathVariable uid: String, @PathVariable group_id: String,
        @RequestHeader("Authorization") authorization: String?
    ): ResponseEntity<Any> {


        authorization ?: return unauthorized(
            "Unauthorized Access",
            "No authorization token provided."
        )

        val user = userService.read(uid) ?: return notFound(
            "User not found",
            "Since the user $uid was not found, no group was found either."
        )

        if(!verifyJwtAgainstEmail(authorization, user.email)) return unauthorized(
            "Unauthorized Access",
            "User email different from the one provided in the token."
        )

        val group =
            groupService.read(group_id, uid) ?: return notFound(
                "Group not found",
                "Couldn't find group with id $group_id."
            )

        return jsonResponse(group)
    }

    @PostMapping("")
    fun postGroup(
        @PathVariable uid: String, @RequestBody budGroup: BudGroupInputModel,
        @RequestHeader("Authorization") authorization: String?
    ): ResponseEntity<Any> {

        authorization ?: return unauthorized(
            "Unauthorized Access",
            "No authorization token provided."
        )

        val user = userService.read(uid) ?: return notFound(
            "User not found",
            "Since the user $uid was not found, no group was found either."
        )

        if(!verifyJwtAgainstEmail(authorization, user.email)) return unauthorized(
            "Unauthorized Access",
            "User email different from the one provided in the token."
        )


        val group = groupService.create(BudGroup(budGroup.name, Date(), ""), uid)
        return jsonResponse(group)
    }

    @PutMapping("/{group_id}")
    fun putGroup(
        @PathVariable uid: String, @PathVariable group_id: String, @RequestBody budGroup: BudGroupInputModel,
        @RequestHeader("Authorization") authorization: String?
    ): ResponseEntity<Any> {

        authorization ?: return unauthorized(
            "Unauthorized Access",
            "No authorization token provided."
        )

        val user = userService.read(uid) ?: return notFound(
            "User not found",
            "Since the user $uid was not found, no group was found either."
        )

        if(!verifyJwtAgainstEmail(authorization, user.email)) return unauthorized(
            "Unauthorized Access",
            "User email different from the one provided in the token."
        )

        val group = groupService.update(BudGroup(budGroup.name, Date(), group_id), uid)
        return jsonResponse(group)
    }


    @DeleteMapping("/{group_id}")
    fun deleteGroup(
        @PathVariable uid: String, @PathVariable group_id: String,
        @RequestHeader("Authorization") authorization: String?
    ): ResponseEntity<Any> {

        authorization ?: return unauthorized(
            "Unauthorized Access",
            "No authorization token provided."
        )

        val user = userService.read(uid) ?: return notFound(
            "User not found",
            "Since the user $uid was not found, no group was found either."
        )

        if(!verifyJwtAgainstEmail(authorization, user.email)) return unauthorized(
            "Unauthorized Access",
            "User email different from the one provided in the token."
        )

        val group = groupService.delete(group_id, uid) ?: return notFound(
            "about:blank",
            "Group Doesn't Exist",
            "This Group with the id '$group_id' does not exist in the database."
        )

        return jsonResponse(group)
    }
}