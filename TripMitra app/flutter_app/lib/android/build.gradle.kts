allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir = file("../../build")
rootProject.buildDir = newBuildDir

subprojects {
    afterEvaluate {
        project.buildDir = File(rootProject.buildDir, project.name)
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
