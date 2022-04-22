# doasedit

sudoedit for doas

## Installation

```sh
git clone https://git.stefanwimmer128.eu/stefanwimmer128/doasedit.git
cd doasedit
git checkout v2.1.1
make
doas make install
```

Ensure the following line at the top of `doas.conf`:

```
permit nopass root
```

## Usage

```sh
doasedit /file/to/edit
```

For additional help see: `doasedit -h`
