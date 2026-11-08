"""Patches the Android project created by `flutter create` so that the app
builds with the permissions and settings it needs. Run from the project root."""
import glob
import re
import sys

MANIFEST = 'android/app/src/main/AndroidManifest.xml'

PERMISSIONS = """
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
    <queries>
        <intent><action android:name="android.intent.action.VIEW"/><data android:scheme="https"/></intent>
        <intent><action android:name="android.intent.action.VIEW"/><data android:scheme="mailto"/></intent>
        <intent><action android:name="android.intent.action.VIEW"/><data android:scheme="tel"/></intent>
    </queries>
"""

RECEIVERS = """
        <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver"/>
        <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED"/>
            </intent-filter>
        </receiver>
"""


def patch_manifest():
    s = open(MANIFEST, encoding='utf-8').read()
    if 'ACCESS_FINE_LOCATION' in s:
        return
    # permissions and queries go right before <application
    s = s.replace('<application', PERMISSIONS + '    <application', 1)
    # app name on the home screen
    s = re.sub(r'android:label="[^"]*"', 'android:label="ইমান আনো"', s, count=1)
    # notification receivers go right before </application>
    s = s.replace('</application>', RECEIVERS + '    </application>', 1)
    open(MANIFEST, 'w', encoding='utf-8').write(s)


def patch_gradle():
    files = glob.glob('android/app/build.gradle.kts') + glob.glob('android/app/build.gradle')
    if not files:
        sys.exit('No android/app/build.gradle(.kts) found')
    path = files[0]
    kts = path.endswith('.kts')
    s = open(path, encoding='utf-8').read()

    # minSdk 23
    s = re.sub(r'minSdk\s*=\s*flutter\.minSdkVersion', 'minSdk = 23', s)
    s = re.sub(r'minSdkVersion\s+flutter\.minSdkVersion', 'minSdkVersion 23', s)

    # core library desugaring (needed by flutter_local_notifications)
    if 'coreLibraryDesugaring' not in s:
        flag = 'isCoreLibraryDesugaringEnabled = true' if kts else 'coreLibraryDesugaringEnabled true'
        s = re.sub(r'(compileOptions\s*\{)', r'\1\n        ' + flag, s, count=1)
        dep = ('\ndependencies {\n    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")\n}\n'
               if kts else
               '\ndependencies {\n    coreLibraryDesugaring \'com.android.tools:desugar_jdk_libs:2.0.4\'\n}\n')
        s += dep
    open(path, 'w', encoding='utf-8').write(s)


patch_manifest()
patch_gradle()
print('Android project patched.')
