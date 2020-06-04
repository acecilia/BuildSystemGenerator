**EXTENSION**

# `PartiallyTyped`
```swift
extension PartiallyTyped: Encodable where Typed: Encodable, Untyped: Encodable
```

## Methods
### `encode(to:)`

```swift
public func encode(to encoder: Encoder) throws
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| encoder | The encoder to write data to. |

### `init(from:)`

```swift
public init(from decoder: Decoder) throws
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| decoder | The decoder to read data from. |