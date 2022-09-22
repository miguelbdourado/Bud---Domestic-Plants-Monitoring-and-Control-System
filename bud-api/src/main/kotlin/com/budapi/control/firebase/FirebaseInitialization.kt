package com.budapi.control.firebase

import com.google.auth.oauth2.GoogleCredentials
import com.google.firebase.FirebaseApp
import com.google.firebase.FirebaseOptions
import com.google.firebase.FirebaseOptions.builder
import org.springframework.stereotype.Service
import java.io.FileInputStream
import javax.annotation.PostConstruct


@Service
class FirebaseInitialization {


    @PostConstruct
    fun initialization() {
        val serviceAccount = FileInputStream(System.getenv("GOOGLE_APPLICATION_CREDENTIALS"))

        val options: FirebaseOptions = builder()
            .setCredentials(GoogleCredentials.fromStream(serviceAccount))
            .build()

        FirebaseApp.initializeApp(options)
    }
}