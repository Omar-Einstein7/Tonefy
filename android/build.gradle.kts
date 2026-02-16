allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    // Fix for on_audio_query namespace
    if (project.name == "on_audio_query_android") {
        val configureNamespace = {
             val android = project.extensions.findByName("android")
             if (android != null) {
                 try {
                     val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                     setNamespace.invoke(android, "com.lucasjosino.on_audio_query")
                     println("Fixed namespace for ${project.name}")
                 } catch (e: Exception) {
                     println("Failed to set namespace for ${project.name}: ${e.message}")
                 }
             }
        }

        if (project.state.executed) {
            configureNamespace()
        } else {
            project.afterEvaluate {
                configureNamespace()
            }
        }
    }

    // Force compileSdk 36 for all android modules
    val configureCompileSdk = {
        val android = project.extensions.findByName("android")
        if (android != null) {
             try {
                 // compileSdk = 36
                 val setCompileSdk = android.javaClass.getMethod("setCompileSdkVersion", Int::class.javaPrimitiveType)
                 setCompileSdk.invoke(android, 36)
                 println("Forced compileSdk to 36 for ${project.name}")
             } catch (e: Exception) {
                  // ignore
             }
        }
    }

    if (project.state.executed) {
        configureCompileSdk()
    } else {
        project.afterEvaluate {
            configureCompileSdk()
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
