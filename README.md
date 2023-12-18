# presenter-account-consumer

### Overview
A consumer that reads created presenter messages and adds presenters into the XMLGW database. 
A presenter account is needed to file via the XMLGW.

### Design Document 
[Presenter Account Design Proposal](https://companieshouse.atlassian.net/wiki/spaces/ADG/pages/4352933895/Design+Proposal+-+Create+a+Presenter+Account+Service)

### Requirements
In order to run the service locally you will need the following:
- [Java 21](https://www.oracle.com/java/technologies/downloads/#java21)
- [Maven](https://maven.apache.org/download.cgi)
- [Git](https://git-scm.com/downloads)

### Getting started
To checkout and build the service:
1. Clone [Docker CHS Development](https://github.com/companieshouse/docker-chs-development) and follow the steps in the README.
2. Run `./bin/chs-dev` modules enable `presenter-account-consumer`
3. Run `./bin/chs-dev` development enable `presenter-account-consumer`
4. Run docker using `"tilt up"` in the `docker-chs-development` directory.
5. Use spacebar in the command line to open tilt window - wait for `presenter-account-consumer` to become green.

These instructions are for a local docker environment.

### Endpoints

The full path for each public endpoints:
`${API_URL}/presenter-account-consumer/`

|Method    | Path                                                  | Description |
|:---------|:------------------------------------------------------|:----------- |
|**GET**   | `/healthcheck`                                        | Returns `HTTPS.OK` which means api is up and runing |
