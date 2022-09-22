package com.budapi.util

import com.fasterxml.jackson.annotation.JsonProperty
import com.fasterxml.jackson.databind.ObjectMapper
import com.google.gson.annotations.JsonAdapter
import com.google.gson.annotations.SerializedName
import java.util.*

fun decodeAndGetPayload ( jwt : String) : Payload{

    val objectMapper = ObjectMapper()
    val json = jwt.split(".")[1]
    val decodedBytes: ByteArray = Base64.getDecoder().decode(json)
    val decodedString = String(decodedBytes)
    return objectMapper.readValue(decodedString, Payload::class.java)
}

fun verifyJwtAgainstEmail(jwt: String, email : String) : Boolean {
    val payload = decodeAndGetPayload(jwt)
    return payload.email == email
}

data class Payload(
    val name : String = "",
    val picture : String = "",
    val iss : String = "",
    val aud : String = "",
    val auth_time : Long = -1,
    val user_id : String = "",
    val sub : String = "",
    val iat : Long = -1,
    val exp : Long = -1,
    val email : String = "",
    val email_verified : String = "",
    val firebase : Firebase?,

) {
    constructor() : this(firebase= Firebase())
}

data class Firebase(
    val identities : Identities?,
    val sign_in_provider : String = "",
) {
    constructor() : this(Identities())
}

data class Identities(
    @JsonProperty("google.com")
    val google: Array<String>,
    @JsonProperty("email")
    val email:Array<String>,
) {
    constructor() : this(emptyArray(), emptyArray())
}