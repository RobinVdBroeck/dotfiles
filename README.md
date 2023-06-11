You can install the dotfiles by running following commands:

```bash
git clone --recurse-submodules git@github.com:RobinVdBroeck/dotfiles.git
cd dotfiles
./install.sh
```

### Setup git blame 
Run following command to ignore formatting commits:
```sh
git config blame.ignoreRevsFile .git-blame-ignore-revs
```

