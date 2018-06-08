# CoJezdzi
[ReSwift](https://github.com/ReSwift/ReSwift) take on a iOS application that shows trams and busses locations in Warsaw.

Go to `https://api.um.warszawa.pl` and get your own API key and create:

```swift
extension  WarsawApiConstants.ParamValue {
    static let APIKey = "your api key here"
}
```

anywhere in the project.

[About app](https://avantapp.wordpress.com/co-jezdzi/)

# Plans

## Desired Architecture

```
                            +----------------+
                          8 |                |
            +-------------+ |     Store      | <-------------+
            |               |                |               |
            |               +----------------+               |
            v                                                + 7
    +----------------+       +----------------+       +----------------+ 5     +----------------+
    |                | 1     |      View      | 4     |                | +---> |                |
    |   Observable   | +---> |   Controller   | +---> |    Use Case    |       |   Side Effect  |
    |                |       |                |       |                | <---+ |                |
    +----------------+       +----------------+       +----------------+     6 +----------------+
                                    2+     ^
                                    |     |
                                    v     +3
                            +----------------+
                            |                |
                            |      View      |
                            |                |
                            +----------------+
```