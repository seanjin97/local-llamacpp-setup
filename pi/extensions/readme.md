# Steps to regenerate

## 1: Clone the example/extensions

```sh
git clone --depth=1 git@github.com:badlogic/pi-mono.git
```

## 2: Pick and choose what you need

```sh
cp -R pi-mono/packages/coding-agent/examples/extensions/plan-mode extensions/plan-mode
cp -R pi-mono/packages/coding-agent/examples/extensions/sandbox extensions/sandbox
cp -R pi-mono/packages/coding-agent/examples/extensions/permission-gate.ts extensions/permission-gate.ts
```

## 3: Install whatever required

### Sandbox install

#### If on linux

```sh
sudo apt-get install bubblewrap socat ripgrep
```

```sh
cd sandbox && npm i
```

If you see some weird error like this due to the sandbox

```log
bwrap: Can't mount tmpfs on /newroot/<whatever>/.aws: No such file or directory
```

Do this

```sh
cd ~
ln -s /mnt/c/Users/<ur username>/.aws ~/.aws
```

#### If you see some weird error like

## 4: Symlink to the actual agents repository for the agent to auto discover it

```sh
ln -s "$(pwd)/extensions" ~/.pi/agent
```
