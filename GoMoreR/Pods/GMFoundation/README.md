# iOS Foundation

iOS App 專用模組，包含：

- Swift Extension



## 更新步驟

步驟1：修改 GMFoundation.podspec

```
spec.version      = "X.X.X"
```

步驟2：Commit所有更新

步驟3：更新Tag

步驟4：第一次更新時，只要執行過此步驟，下次更新可以省略

```
pod repo add GMFoundation https://github.com/bOMDIC/Kit_iOS_Foundation
```

步驟5：Push 到 .podspec

```
pod repo push --allow-warnings GMFoundation GMFoundation.podspec
```

## App pod file

```
pod 'GMFoundation', :git => 'https://github.com/bOMDIC/Kit_iOS_Foundation.git'
```
