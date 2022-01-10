# doasedit

## Installation

### Manual installation

```sh
git clone https://git.stefanwimmer128.eu/stefanwimmer128/doasedit.git
cd doasedit
git checkout v1.0.3
./configure.sh
doas ./install.sh install
```

Ensure the following line at the top of `doas.conf`:

```
permit nopass root
```

To change installation configuration see: `./configure -h`

To uninstall run: `doas ./install.sh remove`

## Usage

```sh
doasedit /file/to/edit
```

For additional help see: `doasedit -h`
