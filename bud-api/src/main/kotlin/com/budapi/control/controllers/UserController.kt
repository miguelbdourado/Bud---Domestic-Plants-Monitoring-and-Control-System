package com.budapi.control.controllers

import com.budapi.control.firebase.service.UserService
import com.budapi.model.User
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

data class UserInputModel(
    val admin: Boolean?,
    val name: String,
    val uid: String,
    val email: String,
)

@RestController
@RequestMapping("bud-api/user", headers = ["Accept=application/json"])
class UserController(val userService: UserService) {

    @GetMapping("")
    fun getUsers(): ResponseEntity<Any> {
        val users = userService.readAll()

        return jsonResponse(users)
    }

    @GetMapping("/{uid}")
    fun getUser(@PathVariable uid: String,
                @RequestHeader("Authorization") authorization : String?): ResponseEntity<Any> {


        authorization ?: return unauthorized(
            "Unauthorized Access",
            "No authorization token provided."
        )

        val user = userService.read(uid) ?: return notFound(
            "User not found",
            "User was not found."
        )

        if(!verifyJwtAgainstEmail(authorization, user.email)) return unauthorized(
            "Unauthorized Access",
            "User email different from the one provided in the token."
        )

        return jsonResponse(user)
    }

    @PostMapping("")
    fun postUser(@RequestBody user: UserInputModel): ResponseEntity<Any> {

        if (userService.read(user.uid) != null) return problemResponse(
            "about:blank",
            "User already Exists.",
            409,
            "This user is already present in the database."
        )

        val user = User(
            admin = user.admin ?: false,
            uid = user.uid,
            name = user.name,
            email = user.email
        )
        userService.create(user)

        return jsonResponse(user)
    }

    @PutMapping("")
    fun putUser(@RequestBody user: UserInputModel): ResponseEntity<Any> {
        val user = User(
            admin = user.admin ?: false,
            uid = user.uid,
            name = user.name,
            email = user.email
        )
        userService.create(user)
        return jsonResponse(user)
    }

    @DeleteMapping("/{uid}")
    fun deleteUser(@PathVariable uid: String,
                   @RequestHeader("Authorization") authorization : String?): ResponseEntity<Any> {

        authorization ?: return unauthorized(
            "Unauthorized Access",
            "No authorization token provided."
        )

        val user = userService.read(uid) ?: return notFound(
            "User not found",
            "User was not found."
        )

        if(!verifyJwtAgainstEmail(authorization, user.email)) return unauthorized(
            "Unauthorized Access",
            "User email different from the one provided in the token."
        )
        return jsonResponse(user)
    }


}
