textbus
=======

SMS interface for MBTA predictions data. People without smartphones will be able to get real-time predictions.


Setup
=====

Clone the repo:

```sh
$ git clone git@github.com:beechnut/textbus.git
$ cd textbus
```

We assume you've installed Ruby and RVM already.

Install the dependencies

```sh
$ bundle install
```

Then run the app with [Foreman](https://github.com/ddollar/foreman)! Foreman lets you run multiple proceses concurrently.

```
$ foreman start
```

If you see errors that certain things aren't writable, just `mkdir` to make the folders it's trying to write to.

```
$ mkdir tmp
$ mkdir tmp/pids
$ mkdir log
```

(If you're wondering why all the hassle, it's because we're using a dev environment very similar to our intended production environment, which is a unicorn server being run by Foreman.)

Once all the mkdirs are in place, it should be running.