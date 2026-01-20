allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
subprojects {
    project.extra.set("org.gradle.parallel", false) // Helps with evaluation order
    
    if (project.name == "agora_uikit") {
        plugins.withType<com.android.build.gradle.LibraryPlugin> {
            extensions.configure<com.android.build.gradle.LibraryExtension> {
                namespace = "io.agora.uikit"
            }
        }
    }
}
