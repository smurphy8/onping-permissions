# onping-permissions

Onping Permissions is a simple graph generator that allows you to quickly create an SVG representing the permission tree of
a set of onping permissions.

In addition to this functionality, it allows branch checking 

## Installation

cabal install --enable-tests

## Usage

first wrap in some sort of daemon with the yml file that points it to the correct mongo instance for onping.

It is then accessed with simple wai commands.

## How to run tests

```
cabal configure --enable-tests && cabal build && cabal test
```

## Contributing

Please understand that we make this code available for people to use as examples.  If you see something wrong and would like to
fix it, great!  But it isn't really a public project though it is an open source one.
