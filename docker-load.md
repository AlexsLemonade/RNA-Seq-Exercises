
## Loading Docker image from flash drives

_2019 Chicago Workshop_

### Copy files from the flash drives

Copy `ccdl_training_rnaseq.tar.gz` from the flash drives we have distributed to your Desktop folder

### Next steps

* [Mac OS X and Linux](#mac-os-x-and-linux)
* [Windows 10 Pro](#windows-10-pro)

#### Mac OS X and Linux

1. Open `Terminal`. You can use Spotlight Search on a Mac to find this application.

2. You can navigate to your Desktop directory by copying and pasting this command into Terminal (hit Enter):

```
cd Desktop
```

3. Once you are in your Desktop directory, you must extract the file with the following command:

```
gunzip ccdl_training_rnaseq.tar.gz
```

4. You can then load the Docker image with `docker load`:

```
docker load -i ccdl_training_rnaseq.tar
```

This will take a minute.

5. When this step completes, check that it was successful with:

```
docker images
```

You should see output like:

```
REPOSITORY                         TAG                 IMAGE ID            CREATED             SIZE
ccdl/training_rnaseq               2019-chicago        22f2b4f05051        3 days ago          5.28GB
```

_Note that the created field may not match._

#### Windows 10 Pro

Make sure you have 7-Zip installed.
If you do not, you can download the `64-bit x64` program here: https://www.7-zip.org/

1. Right-click `ccdl_training_rnaseq.tar.gz`.
2. Go to `7-Zip` and selected `Extract Here`.
When that has finished extraction, you should see `ccdl_training_rnaseq.tar` on your Desktop.

3. Open your `Command Prompt` application.
4. Navigate to your `Desktop` directory with:

```
cd Desktop
```
5. You can load the Docker image with `docker load`:

```
docker load -i ccdl_training_rnaseq.tar
```

This will take a minute.

6. When this step completes, check that it was successful with:

```
docker images
```

You should see output like:

```
REPOSITORY                         TAG                 IMAGE ID            CREATED             SIZE
ccdl/training_rnaseq               2019-chicago        19c5bb6657d3        3 days ago          4.82GB
```

_Note that the created field may not match._
