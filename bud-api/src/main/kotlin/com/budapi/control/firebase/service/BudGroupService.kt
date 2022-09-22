package com.budapi.control.firebase.service

import com.budapi.model.BudGroup
import com.budapi.model.User
import com.google.cloud.firestore.Firestore
import com.google.firebase.cloud.FirestoreClient
import org.springframework.stereotype.Service

@Service
class BudGroupService {

    private val USER_COLLECTION_NAME = "User"
    private val BUD_GROUP_COLLECTION_NAME = "Bud Group"

    fun create(group: BudGroup, uid: String): BudGroup? {
        val dbFireStore: Firestore = FirestoreClient.getFirestore()
        val collectionApiFuture = dbFireStore.collection(USER_COLLECTION_NAME).document(uid)
        val id = collectionApiFuture.collection(BUD_GROUP_COLLECTION_NAME).document()
        group.group_id = id.id
        id.set(group)
        return collectionApiFuture.collection(BUD_GROUP_COLLECTION_NAME).document(id.id).get().get().toObject(BudGroup::class.java)
    }

    fun read(group_id: String, uid: String): BudGroup? {
        val dbFireStore: Firestore = FirestoreClient.getFirestore()
        val document = dbFireStore.collection(USER_COLLECTION_NAME).document(uid).collection(BUD_GROUP_COLLECTION_NAME).document(group_id)

        return document.get().get().toObject(BudGroup::class.java)
    }

    fun update(group: BudGroup, uid: String): BudGroup? {
        val dbFireStore: Firestore = FirestoreClient.getFirestore()
        val collectionApiFuture = dbFireStore.collection(USER_COLLECTION_NAME).document(uid)
        collectionApiFuture.collection(BUD_GROUP_COLLECTION_NAME).document(group.group_id!!).set(group)
        return group
    }

    fun delete(group_id: String, uid: String): BudGroup? {

        val dbFireStore: Firestore = FirestoreClient.getFirestore()
        val document = dbFireStore.collection(USER_COLLECTION_NAME).document(uid).collection(BUD_GROUP_COLLECTION_NAME).document(group_id)

        val group = document.get().get().toObject(BudGroup::class.java)
        document.delete()

        return group
    }

    fun readAll(uid: String): List<BudGroup?> {
        val dbFireStore: Firestore = FirestoreClient.getFirestore()

        val groups = mutableListOf<BudGroup?>()

        val documentCollection = dbFireStore.collection(USER_COLLECTION_NAME).document(uid).collection(BUD_GROUP_COLLECTION_NAME).listDocuments()
        for(document in documentCollection) {
            groups.add(document.get().get().toObject(BudGroup::class.java))
        }
        return groups
    }
}