Do you think it's annoying having to drag and drop images in your iOS app Asset Catalog
every time an icon changes? Did you get the right image on the right size?
Do you think it's a pain in the ass dealing with lots of sizes of the icon?
Do you think these things could be automated?

*Yes, they can be.*

## About

The appicon gem lets you only ever care about one icon, eg. the 1024x1024 iTunes version.
The tool will check which sizes you have set up for your app icon in your Asset Catalog,
generate all those icons for you and install them in your Asset Catalog. Done.

## Installation

```
    $ gem install appicon
```

Appicon uses ImageMagick (http://www.imagemagick.org) for image conversion. Install it using brew:

```
    $ brew install imagemagick
```

Not sure if you've already got imagemagick? Check:
```
    $ convert --version
```


## Usage

```
    $ appicon install iTunesIcon-1024x1024.png path/to/Images.xcassets
```

## Contact

Found a bug or missing something? Let me know, or even better, file a pull request!

Erik Sundin

- erik@eriksundin.se

## License

Appicon gem is available under the MIT license. See the LICENSE file for more info.
