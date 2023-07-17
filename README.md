# Docker RTL
## Semi-automated container environment for RTL with CLN

### This project is made to be used with [docker-cln](https://github.com/mrbitcoiner/docker-cln)

### Instructions

* Observation: Follow the instructions when running the control script

* Clone this repository
* Change directory to this repository
```bash
cd docker-cln
```

* Build the image
```bash
./control.sh build
```

* Start the RTL container
```bash
./control.sh up
```

* Go to http://localhost:3000 and be happy

* Stop the RTL container
```bash
./control.sh down
```

