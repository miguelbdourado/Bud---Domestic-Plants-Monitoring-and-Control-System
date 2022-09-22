package com.budapi.control.firebase.service

import com.budapi.model.Bud
import com.budapi.model.BudGroup
import com.google.cloud.firestore.Firestore
import com.google.firebase.cloud.FirestoreClient
import org.springframework.stereotype.Service

@Service
class BudService {

    private val USER_COLLECTION_NAME = "User"
    private val BUD_GROUP_COLLECTION_NAME = "Bud Group"
    private val BUD_COLLECTION_NAME = "Bud"

    fun create(bud: Bud, uid: String, group_id: String): Bud? {
        val dbFireStore: Firestore = FirestoreClient.getFirestore()
        val collectionApiFuture =
            dbFireStore.collection(USER_COLLECTION_NAME).document(uid).collection(BUD_GROUP_COLLECTION_NAME)
                .document(group_id)
        val id = collectionApiFuture.collection(BUD_COLLECTION_NAME).document()
        bud.id = id.id
        id.set(bud).get()

        return collectionApiFuture.collection(BUD_COLLECTION_NAME).document(id.id).get().get().toObject(Bud::class.java)
    }

    fun read(uid: String, group_id: String, bud_id: String): Bud? {
        val dbFireStore: Firestore = FirestoreClient.getFirestore()

        val document =
            dbFireStore.collection(USER_COLLECTION_NAME).document(uid).collection(BUD_GROUP_COLLECTION_NAME)
                .document(group_id).collection(BUD_COLLECTION_NAME).document(bud_id)

        return document.get().get().toObject(Bud::class.java)
    }

    fun update(bud: Bud, uid: String, group_id: String): Bud? {
        val dbFireStore: Firestore = FirestoreClient.getFirestore()
        val collectionApiFuture = dbFireStore.collection(USER_COLLECTION_NAME).document(uid)
        collectionApiFuture.collection(BUD_GROUP_COLLECTION_NAME).document(group_id).collection(BUD_COLLECTION_NAME).document(bud.id!!).set(bud)
        return bud
    }

    fun delete(bud_id: String, group_id: String, uid: String): Bud? {
        val dbFireStore: Firestore = FirestoreClient.getFirestore()
        val document = dbFireStore.collection(USER_COLLECTION_NAME).document(uid).collection(BUD_GROUP_COLLECTION_NAME).document(group_id).collection(BUD_COLLECTION_NAME).document(bud_id)

        val bud = document.get().get().toObject(Bud::class.java)
        document.delete()

        return bud
    }

    fun readAll(uid: String, group_id: String): List<Bud?> {
        val dbFireStore: Firestore = FirestoreClient.getFirestore()

        val buds = mutableListOf<Bud?>()

        val documentCollection =
            dbFireStore.collection(USER_COLLECTION_NAME).document(uid).collection(BUD_GROUP_COLLECTION_NAME)
                .document(group_id).collection(BUD_COLLECTION_NAME).listDocuments()

        for (document in documentCollection) {
            buds.add(document.get().get().toObject(Bud::class.java))
        }
        return buds
    }

}