# Automated certificates regeneration

Automaticaly regenerate a server certificate.

Warning! Need to be secured in a production environment. (the script folder should be accessible only by root)

How it works : it reads the content of `certificates.txt` (each line must have only
one domain name) and it generates a certificate for this domain based on a certification autority (or intermediate certification authority). This script can be configured as a system cron.


## Project's structure

- `certificates` : Contains the generated certificates
- `config` : Contains temporary files plus OpenSSL configuration
- `certificates.txt` : Contains the certificates list
- `README.md` : This readme file
- `regenerate.sh` : The main project script


## Installation

To install the script, you should follow these steps 
1. Download & extract the project in a protected folder of your system.
2. Make the certificate folder secure using a command such as `chown root:root -R /path/to/certificate/generator && chmod 700 -R /path/to/certificate/generator`
3. Fill `certificates.txt` (or make a script fill it automatically) with the domains to generate.
4. Review `config/openssl.conf` to make the defaults values match with your requirements.
5. Install the script as a system cron using the command `sudo crontab -e`