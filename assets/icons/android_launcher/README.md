# Android Launcher Icons Staging Area

This directory is prepared for your custom Android launcher icons.

Flutter and Android require specific icon sizes to ensure crisp display across all device screen densities. Once your designer provides the icon assets, place the appropriately sized `ic_launcher.png` files into their respective subfolders.

## How to apply these icons to the app:

Once you have added the icons to these folders, you can apply them to the actual Android build by manually copying them to their corresponding directories in the native Android structure:

* Copy `mdpi/ic_launcher.png` -> to -> `android/app/src/main/res/mipmap-mdpi/`
* Copy `hdpi/ic_launcher.png` -> to -> `android/app/src/main/res/mipmap-hdpi/`
* Copy `xhdpi/ic_launcher.png` -> to -> `android/app/src/main/res/mipmap-xhdpi/`
* Copy `xxhdpi/ic_launcher.png` -> to -> `android/app/src/main/res/mipmap-xxhdpi/`
* Copy `xxxhdpi/ic_launcher.png` -> to -> `android/app/src/main/res/mipmap-xxxhdpi/`

*Note: You can also use a package like `flutter_launcher_icons` in the future to fully automate this, but this staging area allows you to cleanly organize the raw assets manually first.*
