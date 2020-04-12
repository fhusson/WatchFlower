TARGET  = WatchFlower

VERSION = 0.12
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

CONFIG += c++11
QT     += core bluetooth sql
QT     += qml quickcontrols2 charts svg
android { QT += androidextras }
ios { QT += gui-private }

# Validate Qt version
if (lessThan(QT_MAJOR_VERSION, 5) | lessThan(QT_MINOR_VERSION, 10)) {
    error("You need AT LEAST Qt 5.10 to build $${TARGET}")
}

# Project features #############################################################

# Use Qt Quick compiler
ios | android { CONFIG += qtquickcompiler }

# StatusBar for mobile OS
include(src/thirdparty/StatusBar/statusbar.pri)

# SingleApplication for desktop OS
!ios | !android {
    include(src/thirdparty/SingleApplication/singleapplication.pri)
    DEFINES += QAPPLICATION_CLASS=QApplication
}

# Demo mode (for screenshots across devices)
exists(assets/demo/demo_bdd.db) {
    DEFINES += DEMO_MODE
    RESOURCES += assets/demo/demo.qrc
}

# Force mobile UI
#DEFINES += FORCE_MOBILE_UI

# Project files ################################################################

SOURCES  += src/main.cpp \
            src/settingsmanager.cpp \
            src/systraymanager.cpp \
            src/notificationmanager.cpp \
            src/devicemanager.cpp \
            src/device.cpp \
            src/device_flowercare.cpp \
            src/device_hygrotemp_lcd.cpp \
            src/device_hygrotemp_eink.cpp \
            src/device_hygrotemp_clock.cpp \
            src/device_ropot.cpp \
            src/utils_app.cpp \
            src/utils_android.cpp \
            src/utils_screen.cpp

HEADERS  += src/demomode.h \
            src/settingsmanager.h \
            src/systraymanager.h \
            src/notificationmanager.h \
            src/devicemanager.h \
            src/device.h \
            src/device_flowercare.h \
            src/device_hygrotemp_lcd.h \
            src/device_hygrotemp_eink.h \
            src/device_hygrotemp_clock.h \
            src/device_ropot.h \
            src/utils_app.h \
            src/utils_android.h \
            src/utils_screen.h \
            src/utils_versionchecker.h

RESOURCES   += qml/qml.qrc \
               i18n/i18n.qrc \
               assets/assets.qrc

OTHER_FILES += .gitignore \
               .travis.yml

TRANSLATIONS = i18n/watchflower_de.ts \
               i18n/watchflower_es.ts \
               i18n/watchflower_fr.ts \
               i18n/watchflower_ru.ts

lupdate_only { SOURCES += qml/*.qml qml/*.js qml/components/*.qml }

# Build settings ###############################################################

unix {
    # Enables AddressSanitizer
    #QMAKE_CXXFLAGS += -fsanitize=address,undefined
    #QMAKE_LFLAGS += -fsanitize=address,undefined

    #QMAKE_CXXFLAGS += -Wno-nullability-completeness
}

DEFINES += QT_DEPRECATED_WARNINGS

CONFIG(release, debug|release) : DEFINES += QT_NO_DEBUG_OUTPUT

# Build artifacts ##############################################################

OBJECTS_DIR = build/
MOC_DIR     = build/
RCC_DIR     = build/
UI_DIR      = build/
QMLCACHE_DIR= build/

DESTDIR     = bin/

################################################################################
# Application deployment and installation steps

linux:!android {
    TARGET = $$lower($${TARGET})

    # Automatic application packaging # Needs linuxdeployqt installed
    #system(linuxdeployqt $${OUT_PWD}/$${DESTDIR}/ -qmldir=qml/)

    # Application packaging # Needs linuxdeployqt installed
    #deploy.commands = $${OUT_PWD}/$${DESTDIR}/ -qmldir=qml/
    #install.depends = deploy
    #QMAKE_EXTRA_TARGETS += install deploy

    # Installation
    isEmpty(PREFIX) { PREFIX = /usr/local }
    target_app.files       += $${OUT_PWD}/$${DESTDIR}/$$lower($${TARGET})
    target_app.path         = $${PREFIX}/bin/
    target_icon.files      += $${OUT_PWD}/assets/logos/$$lower($${TARGET}).svg
    target_icon.path        = $${PREFIX}/share/pixmaps/
    target_appentry.files  += $${OUT_PWD}/assets/linux/$$lower($${TARGET}).desktop
    target_appentry.path    = $${PREFIX}/share/applications
    target_appdata.files   += $${OUT_PWD}/assets/linux/$$lower($${TARGET}).appdata.xml
    target_appdata.path     = $${PREFIX}/share/appdata
    INSTALLS += target_app target_icon target_appentry target_appdata

    # Clean appdir/ and bin/ directories
    #QMAKE_CLEAN += $${OUT_PWD}/$${DESTDIR}/$$lower($${TARGET})
    #QMAKE_CLEAN += $${OUT_PWD}/appdir/
}

android {
    # ANDROID_TARGET_ARCH: [x86_64, armeabi-v7a, arm64-v8a]
    #message("ANDROID_TARGET_ARCH: $$ANDROID_TARGET_ARCH")

    # Bundle name
    QMAKE_TARGET_BUNDLE_PREFIX = com.emeric
    QMAKE_BUNDLE = watchflower

    # 
    OTHER_FILES += assets/android/src/com/emeric/watchflower/NotificationDispatcher.java

    DISTFILES += $${PWD}/assets/android/AndroidManifest.xml
    ANDROID_PACKAGE_SOURCE_DIR = $${PWD}/assets/android
}

macx {
    #QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.12
    #message("QMAKE_MACOSX_DEPLOYMENT_TARGET: $$QMAKE_MACOSX_DEPLOYMENT_TARGET")

    # Bundle name
    QMAKE_TARGET_BUNDLE_PREFIX = com.emeric
    QMAKE_BUNDLE = watchflower

    # OS icons
    ICON = $${PWD}/assets/macos/$$lower($${TARGET}).icns
    #QMAKE_ASSET_CATALOGS_APP_ICON = "AppIcon"
    #QMAKE_ASSET_CATALOGS = $${PWD}/assets/macos/Images.xcassets

    # OS infos
    #QMAKE_INFO_PLIST = $${PWD}/assets/macos/Info.plist

    # MacOSDockManager
    SOURCES += src/macosdockmanager.mm
    HEADERS += src/macosdockmanager.h
    LIBS    += -framework AppKit

    # OS entitlement (sandbox and stuff)
    ENTITLEMENTS.name = CODE_SIGN_ENTITLEMENTS
    ENTITLEMENTS.value = $${PWD}/assets/macos/$$lower($${TARGET}).entitlements
    QMAKE_MAC_XCODE_SETTINGS += ENTITLEMENTS

    #======== Automatic bundle packaging

    # Deploy step (app bundle packaging)
    deploy.commands = macdeployqt $${OUT_PWD}/$${DESTDIR}/$${TARGET}.app -qmldir=qml/ -appstore-compliant
    install.depends = deploy
    QMAKE_EXTRA_TARGETS += install deploy

    # Installation step (note: app bundle packaging)
    isEmpty(PREFIX) { PREFIX = /usr/local }
    target.files += $${OUT_PWD}/${DESTDIR}/${TARGET}.app
    target.path = $$(HOME)/Applications
    INSTALLS += target

    # Clean step
    QMAKE_DISTCLEAN += -r $${OUT_PWD}/${DESTDIR}/${TARGET}.app

    #======== XCode

    # macOS developer settings
    exists($${PWD}/assets/macos/macos_signature.pri) {
        # Must contain values for:
        # QMAKE_DEVELOPMENT_TEAM
        # QMAKE_PROVISIONING_PROFILE
        # QMAKE_XCODE_CODE_SIGN_IDENTITY (optional)
        include($${PWD}/assets/macos/macos_signature.pri)
    }

    # Paths and folders
    QT_BIN_PATH = $$dirname(QMAKE_QMAKE)
    QT_PLUGINS_FOLDER = $$dirname(QT_BIN_PATH)/plugins
    QT_PATH = $$dirname(QT_BIN_PATH)

    # 'xcodeproj' rule / Generate xcode project file
    xcodeproj.commands = export CUSTOM_ENV_VAR=34
    xcodeproj.commands += && $$QMAKE_QMAKE -spec macx-xcode $$PWD/$${TARGET}.pro \
        -o $$OUT_PWD/ CONFIG+=$$BUILD_TYPE CONFIG+=release QMAKE_INCDIR_QT=$$QT_PATH/include \
        QMAKE_LIBDIR=$$QT_PATH/lib QMAKE_MOC=$$QT_PATH/bin/moc QMAKE_QMAKE=$$QT_PATH/bin/qmake
    QMAKE_EXTRA_TARGETS += xcodeproj

    # 'xcodedeploy' rule / Bundle packaging from XCode archive
    CONFIG(release, debug|release): {
        # Get the absolute directory path for XCode archives folder
        XCODE_ARCHIVES_DIRECTORY = $$system(echo ~/Library/Developer/Xcode/Archives)/$$system(date +%Y-%m-%d)
        # Get the newest file that starts with the target name
        XCODE_ARCHIVE_NAME = $$system(cd $$XCODE_ARCHIVES_DIRECTORY && ls | grep -e $${TARGET}* | sort -n -t _ -k 2 | tail -1)
        # This will be the absolute path to the app bundle
        DEPLOYED_APP_PATH = ""
        # If the variable is set to something, it means that we found our archive file
        !isEmpty(XCODE_ARCHIVE_NAME) {
            DEPLOYED_APP_PATH = $$XCODE_ARCHIVES_DIRECTORY/$$XCODE_ARCHIVE_NAME/Products/Applications/$${TARGET}.app
            EXISTS_RESULT = $$system([ ! -e $$quote(\"$$DEPLOYED_APP_PATH\") ] && echo "false" || echo "true")
            # If the archive file doesn't exist, we are going to use the app bunlde in the build directory
            equals(EXISTS_RESULT, false) {
                xcodedeploy.depends += all
                DEPLOYED_APP_PATH = $${OUT_PWD}/$${TARGET}.app
            } else {
                DEPLOYED_APP_PATH = $$quote(\"$$DEPLOYED_APP_PATH\")
            }
        } else {
            warning("Cannot find xcode archive")
            ## Since we cannot find the file, we need to make sure that the project is built so that the app bundle is created
            #xcodedeploy.depends += all
            #DEPLOYED_APP_PATH = $$OUT_PWD/$${TARGET}.app
        }

        BUNDLE_PLUGINS_FOLDER = $$DEPLOYED_APP_PATH/Contents/Plugins

        # The xcodedeploy target runs macdeployqt and removes the unsed files from the bundle
        # Signing is handled by XCode when uploading to the App Store
        xcodedeploy.commands = $$QT_BIN_PATH/macdeployqt $$DEPLOYED_APP_PATH -qmldir=$${PWD}/qml -appstore-compliant

        # dSYM files are bundled with a different bundle ID than the app id and they are rejected by the App Store
        xcodedeploy.commands += && find $$DEPLOYED_APP_PATH/ -name $$quote(\"*.dSYM\") -exec rm -rf -d -f {} +

        QMAKE_EXTRA_TARGETS += xcodedeploy
    }
}

ios {
    #QMAKE_IOS_DEPLOYMENT_TARGET = 11.0
    #message("QMAKE_IOS_DEPLOYMENT_TARGET: $$QMAKE_IOS_DEPLOYMENT_TARGET")

    # Bundle name
    QMAKE_TARGET_BUNDLE_PREFIX = com.emeric.ios
    QMAKE_BUNDLE = watchflower

    # OS icons
    QMAKE_ASSET_CATALOGS_APP_ICON = "AppIcon"
    QMAKE_ASSET_CATALOGS = $${PWD}/assets/ios/Images.xcassets

    # OS infos
    QMAKE_INFO_PLIST = $${PWD}/assets/ios/Info.plist
    QMAKE_APPLE_TARGETED_DEVICE_FAMILY = 1,2 # 1: iPhone / 2: iPad / 1,2: Universal

    # iOS developer settings
    exists($${PWD}/assets/ios/ios_signature.pri) {
        # Must contain values for:
        # QMAKE_DEVELOPMENT_TEAM
        # QMAKE_PROVISIONING_PROFILE
        include($${PWD}/assets/ios/ios_signature.pri)
    }
}

win32 {
    # OS icon
    RC_ICONS = $${PWD}/assets/windows/$$lower($${TARGET}).ico

    # Deploy step
    deploy.commands = $$quote(windeployqt $${OUT_PWD}/$${DESTDIR}/ --qmldir qml/)
    install.depends = deploy
    QMAKE_EXTRA_TARGETS += install deploy

    # Installation step
    # TODO?

    # Clean step
    # TODO
}
