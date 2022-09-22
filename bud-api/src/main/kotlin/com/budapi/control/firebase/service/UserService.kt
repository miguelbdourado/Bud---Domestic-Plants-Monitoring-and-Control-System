package com.budapi.control.firebase.service

import com.budapi.model.User
import com.google.cloud.firestore.Firestore
import com.google.firebase.cloud.FirestoreClient
import org.springframework.stereotype.Service

@Service
class UserService() {

    private val USER_COLLECTION_NAME = "User"


    fun create(user: User) : String {
        val dbFireStore: Firestore = FirestoreClient.getFirestore()
        val collectionApiFuture = dbFireStore.collection(USER_COLLECTION_NAME).document(user.uid).set(user)

        return collectionApiFuture.get().updateTime.toString()
    }

    fun read(uid: String) : User? {
        val dbFireStore: Firestore = FirestoreClient.getFirestore()
        val document = dbFireStore.collection(USER_COLLECTION_NAME).document(uid).get().get()

        return document.toObject(User::class.java)
    }

    fun delete(uid: String): User? {
        val dbFireStore: Firestore = FirestoreClient.getFirestore()
        val document = dbFireStore.collection(USER_COLLECTION_NAME).document(uid).get().get()

        dbFireStore.collection(USER_COLLECTION_NAME).document(uid).delete()

        return document.toObject(User::class.java)
    }

    fun readAll(): List<User?> {
        val dbFireStore: Firestore = FirestoreClient.getFirestore()

        val users = mutableListOf<User?>()

        val documents = dbFireStore.collection(USER_COLLECTION_NAME).listDocuments()
        for(document in documents) {
            users.add(document.get().get().toObject(User::class.java))
        }
        return users
    }


}