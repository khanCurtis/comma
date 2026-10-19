package io.github.khancurtis.comma

import android.content.ComponentName
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// FlutterFragmentActivity is required for fingerprint / face unlock.
class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "comma/app_icon")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isDiscreet" -> result.success(isEnabled(DISCREET))
                    "setDiscreet" -> {
                        val discreet = call.arguments as Boolean
                        // Enable the new entry before disabling the old one so
                        // the app always has a launcher icon.
                        setEnabled(if (discreet) DISCREET else DEFAULT, true)
                        setEnabled(if (discreet) DEFAULT else DISCREET, false)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun component(alias: String) = ComponentName(packageName, "$packageName$alias")

    private fun isEnabled(alias: String): Boolean =
        packageManager.getComponentEnabledSetting(component(alias)) ==
            PackageManager.COMPONENT_ENABLED_STATE_ENABLED

    private fun setEnabled(alias: String, enabled: Boolean) {
        packageManager.setComponentEnabledSetting(
            component(alias),
            if (enabled) PackageManager.COMPONENT_ENABLED_STATE_ENABLED
            else PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
            PackageManager.DONT_KILL_APP,
        )
    }

    companion object {
        private const val DEFAULT = ".LauncherDefault"
        private const val DISCREET = ".LauncherDiscreet"
    }
}
