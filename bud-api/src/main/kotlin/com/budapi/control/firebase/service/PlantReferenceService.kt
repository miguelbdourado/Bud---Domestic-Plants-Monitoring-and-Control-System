package com.budapi.control.firebase.service

import com.budapi.model.Bud
import com.budapi.model.BudGroup
import com.budapi.model.PlantReference
import com.budapi.model.User
import com.google.cloud.firestore.Firestore
import com.google.firebase.cloud.FirestoreClient
import org.springframework.stereotype.Service

@Service
class PlantReferenceService {

    private val PLANT_REFERENCE_COLLECTION_NAME = "Plant_Reference"


    fun create(plant: PlantReference): PlantReference? {
        val dbFireStore: Firestore = FirestoreClient.getFirestore()
        val collectionRef = dbFireStore.collection(PLANT_REFERENCE_COLLECTION_NAME)
        val id = collectionRef.document()

        plant.id = id.id
        id.set(plant)
        return collectionRef.document(id.id).get().get().toObject(PlantReference::class.java)
    }

    fun read(plant_id: String): PlantReference? {
        val dbFireStore: Firestore = FirestoreClient.getFirestore()
        val document = dbFireStore.collection(PLANT_REFERENCE_COLLECTION_NAME).document(plant_id).get().get()

        return document.toObject(PlantReference::class.java)
    }

    fun update(plant: PlantReference): PlantReference? {
        val dbFireStore: Firestore = FirestoreClient.getFirestore()
        dbFireStore.collection(PLANT_REFERENCE_COLLECTION_NAME).document(plant.id!!).set(plant)
        return plant
    }

    fun delete(plant_id: String): PlantReference? {
        val dbFireStore: Firestore = FirestoreClient.getFirestore()
        val document = dbFireStore.collection(PLANT_REFERENCE_COLLECTION_NAME).document(plant_id).get().get()

        dbFireStore.collection(PLANT_REFERENCE_COLLECTION_NAME).document(plant_id).delete()

        return document.toObject(PlantReference::class.java)
    }

    fun readAll(): List<PlantReference?> {
        val dbFireStore: Firestore = FirestoreClient.getFirestore()

        val plants = mutableListOf<PlantReference?>()

        val documents = dbFireStore.collection(PLANT_REFERENCE_COLLECTION_NAME).listDocuments()
        for (document in documents) {
            plants.add(document.get().get().toObject(PlantReference::class.java))
        }
        return plants
    }
}