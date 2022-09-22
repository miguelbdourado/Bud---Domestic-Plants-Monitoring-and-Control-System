package com.budapi.view

import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity


fun <T>jsonResponse(t: T, status: Int = 200) : ResponseEntity<Any> {
    return ResponseEntity
        .status(status)
        .contentType(MediaType.APPLICATION_JSON)
        .body(t)
}



