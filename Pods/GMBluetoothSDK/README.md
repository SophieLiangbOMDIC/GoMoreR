# iOS Kit Bluetooth

iOS App 藍芽模組

## 更新步驟

步驟1：修改 GMBluetoothSDK.podspec

```
spec.version      = "X.X.X"
```

步驟2：Commit所有更新

步驟3：更新Tag

步驟4：第一次更新時，只要執行過此步驟，下次更新可以省略

```
pod repo add GMBluetoothSDK https://github.com/bOMDIC/SDK_iOS_Bluetooth.git
```

步驟5：Push 到 .podspec

```
pod repo push --allow-warnings GMBluetoothSDK GMBluetoothSDK.podspec
```

## App pod file

```
pod 'GMBluetoothSDK', :git => 'https://github.com/bOMDIC/SDK_iOS_Bluetooth.git'
```
