# 💉 DependencyInjection
A library to inject your dependencies via property wrappers

[![Github](https://img.shields.io/badge/contact-%40AlbGarciam-blue)](http://github.com/AlbGarciam)
[![Swift](https://img.shields.io/badge/swift-5-orange)](https://swift.org)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager)
[![codecov](https://codecov.io/gh/AlbGarciam/DependencyInjection/branch/main/graph/badge.svg?token=W10GG4Q53X)](https://codecov.io/gh/AlbGarciam/DependencyInjection)

## 🌟 Features

DependencyInjection allows you to define the dependencies of your app. It exposes a property wrapper to make easier the injection in your instances. Every instance can be resolved at three different levels:
* `instance`: Resolves a unique instance across the entire app
* `shared`: Resolves the instance and allows it to be reused if it is needed on another object
* `global`: The instance will act as a singleton

## 🏗 Usage

There are two separate steps when using `DependencyInjection`

### Register dependecies

Starting on version `1.0.0` `DependencyInjection` makes use of Obj-C runtime to search the injection modules across the final module once the first injection is requested.

In order to declare your module you have to declare a class that conforms to `ModuleContract` and call it `Module`. Once this is done, `DependencyInjection` will consider it when building the injection structure as explained before.

```swift
final class Module: ModuleContract {
    static func get() {
        instance(TypeAContract.self, TypeA.self)
        shared(TypeBContract.self, TypeB.self)
        global(TypeCContract.self, TypeC.self)
    }
}
```

### Injecting instance

To inject an instance you can just use the property wrapper:

```swift
protocol Definition: Injectable {}
class Implementation: Definition {}

@Injected var instance: Definition // It will be Implementation
```

## 🛠 Compatibility

This library can be used on iOS, macOS, iPadOS, watchOS and tvOS as it only relies on Foundation framework

## ⚙️ Installation

You can use the [Swift Package Manager](https://github.com/apple/swift-package-manager) by declaring DependencyInjection as a dependency in your `Package.swift` file:

```swift
.package(url: "https://github.com/AlbGarciam/DependencyInjection", from: "0.1.0")
```

`DependencyInjection` exposes 2 versions of the library, a `static` and a `dynamic` version.

## 🍻 Etc.

- Contributions are very welcome. 
- Attribution is appreciated (let's spread the word!), but not mandatory.

## 👨‍💻 Author

Alberto García – [@AlbGarciam](https://github.com/AlbGarciam)

## 👮‍♂️ License

*DependencyInjection* is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
