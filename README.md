# SHWireGuardKit

A thin wrapper around the WireGuard Apple source files in order to compile it into a protable .xcframework format.


### iOS App Store limitations
This framework is meant to be used by the Network Extension app extension of your application but Apple currently does not allow nested bundles inside apps distributes through the App Store. In order to resolve this problem please add SHWireGuardKit.xcframework as a dependency both to your main app target in Xcode and set it to `Embed & Sign` as well as to your app extension target, but set the embedding build rules to `Do Not Embed`.

### Integration

In order to use this framework either download and install the latest `.xcframework` archive from the releases or add `https://github.com/safehousetech/SHWireGuardKit` as a SPM dependency.

**¡We strongly encourage everybody to explicitly pin specific version numbers if used with SwiftPM!**

The framework is considered stable and breaking changes will be handled through new code paths to preserve existing stable ones. Bug fixes or OS API changes may change the behavior of the framework unintentionally.

### Manual build
The framework can also easily be built locally and only depends on the WireGuard sources which are included as a submodule. A combination of a complete download of this repo as well as the Xcode toolchain should will give you a locally built .xcframework file with slices for iOS & macOS


#### Shell
To build an xcframework for iOS or macOS `cd` into the root folder and run the following command

`./build_framework.sh`

After a successful build a new Finder window will open and highlight the newly built `SHWireGuardKit.xcframework` file. This can now be placed into Xcode via drag & drop
