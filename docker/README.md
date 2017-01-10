
# PowervRA Core Docker image

This docker image is built using PhotonOS 1.0 and PowerShell Core 6.0.0-alpha.14

## Getting Started

Getting started is easy, just run the following commands:

```
docker pull jakkulabs/powervra
docker run --rm -it jakkulabs/powervra
```

## Building a new image

The following steps detail how to build and publish new versions of this docker image.

### Clone the PowervRA repository

```
git clone https://github.com/jakkulabs/PowervRA.git
```

### Change directory to PowervRA\docker

```
cd PowervRA\docker
```

### Build a quick image for testing

```
docker build -f photon/Dockerfile .

```

### Build a named image for publishing

```
docker build -f photon/Dockerfile -t jakkulabs/powervra .
```

### Publish the image

```
docker push jakkulabs/powervra
```