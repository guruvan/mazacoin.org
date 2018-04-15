# MAZA website base

## How To Use

This website uses jekyll. The repo stores the raw website which must be processed by jekyll to prepare for serving

The simplest way to build the site is with docker. A ```Dockerfile``` is included to make this easy for you
The included ```Dockerfile``` will use the ```jekyll/builder``` docker image to process the site, and then install the site 
to a new image based on ```nginx:stable-alpine``` 

Files in the new image are stored in ```/var/www/mazacoin.org``` 
The live site is in ```/var/www/mazacoin.org/_site```

 ```
 git clone https://github.com/mazanetwork/maza.network
 cd maza.network
 docker build -t username/mazacoin-org
 docker run -d -p 80:80 username/mazacoin-org
 ```
 
 The configuration provided for nginx is exceptionally simple, suited for local testing or for the backend of a reverse-proxy configuration

## IPFS

This site is designed to be able to be run directly from IPFS under the domainname of your choice. 
See the wiki for instructions to push the site to IPFS, publish an IPNS link, configure DNS records, and configure nginx to serve the site from IPFS


## Automated Builds 

This site is built by dockerhub, and the [MAZAnetwork jenkins cluster](https://jenkins.maza.network)
You can find automated builds of this image in a few repos on dockerhub
guruvan/mazacoin-org
  Several tags are built by jenkins 
    - guruvan/mazacoin-org:dev
    - guruvan/mazacoin-org:latest
    - guruvan/mazacoin-org:{GIT_COMMIT} 
  Additional tags are built by dockerhub
    - guruvan/mazacoin-org:develop


Multiple pipelines produce this site, and have individual tags. 

### Developing

The easiest way to make changes is probably to follow the above process, but it may be slow if you're making several changes at once 
Alternatively, you can run the jekyll/builder manually, and have jekyll serve the site and watch for your changes 
  ``` 
  git clone https://github.com/mazanetwork/maza.network
  cd maza.network
  sudo chown -R 1000:1000 ./
  docker run -it --rm -v $(pwd):/srv/jekyll jekyll/builder bundle update
  docker run -it --rm -v $(pwd):/srv/jekyll -p 80:8080 jekyll/builder jekyll build serve -P 8080
  ```
Don't edit anything in the ```_site/``` directory as this is overwritten each time the site is processed. 
