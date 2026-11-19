allprojects {
    repositories {
        maven { url = uri("https://maven.aliyun.com/repository/google") }
        maven { url = uri("https://maven.aliyun.com/repository/central") }
        maven { url = uri("https://maven.aliyun.com/repository/public") }
        maven {
            url =
                uri(
                    (System.getenv("FLUTTER_STORAGE_BASE_URL")
                        ?: "https://storage.flutter-io.cn") + "/download.flutter.io",
                )
        }
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

fun forceCompileSdk36(project: Project) {
    val androidExt = project.extensions.findByName("android") ?: return
    for (m in androidExt.javaClass.methods) {
        if (m.parameterCount != 1) continue
        if (m.name != "setCompileSdk" && m.name != "setCompileSdkVersion") continue
        val p0 = m.parameterTypes[0]
        try {
            when {
                p0 == Int::class.javaPrimitiveType || p0 == Integer::class.java -> {
                    m.isAccessible = true
                    m.invoke(androidExt, 36)
                    project.logger.lifecycle(
                        "Forced compileSdk=36 for :${project.name} via ${m.name}(Int)",
                    )
                    return
                }
                p0.name == "java.lang.String" -> {
                    m.isAccessible = true
                    m.invoke(androidExt, "android-36")
                    project.logger.lifecycle(
                        "Forced compileSdk=36 for :${project.name} via ${m.name}(String)",
                    )
                    return
                }
            }
        } catch (t: Throwable) {
            project.logger.warn(
                "compileSdk force failed for :${project.name} via ${m.name}: ${t.message}",
            )
        }
    }
    val names = androidExt.javaClass.methods
        .map { it.name }
        .filter { it.contains("ompile", ignoreCase = true) }
        .distinct()
        .sorted()
    project.logger.lifecycle(
        "No compileSdk setter matched for :${project.name}; methods=$names",
    )
}

fun whenAndroidReady(project: Project, action: () -> Unit) {
    val run = {
        action()
    }
    if (project.state.executed) {
        run()
    } else {
        project.afterEvaluate { run() }
    }
}

subprojects {
    pluginManager.withPlugin("com.android.library") {
        whenAndroidReady(project) { forceCompileSdk36(project) }
    }
    pluginManager.withPlugin("com.android.application") {
        whenAndroidReady(project) { forceCompileSdk36(project) }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
