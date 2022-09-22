package com.budapi

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class BudApiApplication

fun main(args: Array<String>) {
	runApplication<BudApiApplication>(*args)
}
