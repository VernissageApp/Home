# Vernissage

This project is created mainly for storing default settings (like list of instances) available in the app.

## Instances

We have to run periodically application which will refresh `instance2.json` file and all thumbnails stored in the folder. For that reason we have to run commands:

```bash
$ git clone git@github.com:VernissageApp/Home.git
$ cd Home/instances/
$ swift build
$ cd ..
$ rm -rf thumbnails
$ ./instances/.build/debug/instances -i instances.json
```

And after that commands we have to commit and push all changes.
