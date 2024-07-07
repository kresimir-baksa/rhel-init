# rhel-init

## Overview

`rhel-init` is a tool designed to make the command line interface of a Red Hat environment more user-friendly. It includes a variety of scripts located in the `src/scripts` folder that automate and simplify various tasks.

## Features

-   Simplifies command line usage in Red Hat environments.
-   Automates the installation of packages and configurations.
-   Provides a collection of scripts for various administrative tasks.

## Installation

To install `rhel-init`, use the `init.sh` script. This script will guide you through the installation process.

### Basic Installation

Run the following command to start the installation:

```bash
bash rhel-init/init.sh
```

### Automatic Installation

If you want to automatically install all packages without manual intervention, use the `-y` option:

```bash
bash rhel-init/init.sh -y
```

## Requirements

-   This script is designed to run in a Red Hat lab environment.

## Contact

For any questions or suggestions, please open an issue on GitHub.
