# doasedit

## Installation

### Manual installation

Ensure the following line at the top of `doas.conf`:

```
permit nopass root
```

```sh
git clone https://git.stefanwimmer128.eu/stefanwimmer128/doasedit.git
cd doasedit
git checkout v1.0.1
./configure.sh
doas ./install.sh install
```

To change installation configuration see: `./configure -h`

To uninstall run: `doas ./install.sh remove`

## Usage

```sh
doasedit /file/to/edit
```

For additional help see: `doasedit -h`
