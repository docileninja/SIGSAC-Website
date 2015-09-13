# USMA SIGSAC WEBSITE

## About

This is a webserver for the USMA chapter of [ACM SIGSAC](http://www.sigsac.org/) 
(Association for Computing Machinery, Special Interest Group on Security, Audit and Control).
The live site is hosted at http://www.usmasigsac.org.

## Installation

I plan to add a script to spin up an instance on your local machine but currently it 
needs to be done manually. This setup is designed to work best on a LAMP stack
but can be run on Windows or Mac.

1. Make sure you have node.js on your machine. On Ubuntu you can do this with
`sudo apt-get install nodejs npm`.
2. Install coffeescript globally with `npm install -g coffee` so that you can do
`coffee <scriptname>` instead of `node <scriptname>`.
3. (Optional) Install pm2 to use the npm start and stop scripts for this file with
`npm install -g pm2`.
4. Ensure that MySQL is installed and working on your machine. 
(go [here](https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu) for help).
5. Next install the node modules by cd'ing into the cloned directory. Then type `npm install`.
6. Set up MySQL with `mysql -u <username> -p < sigsac.sql`
7. To start the server type `npm start` or `coffee index.coffee`.

## Bug Reporting

If you find any bugs or security flaws in the source or on the website please 
email me at adam.vanpr@gmail.com.