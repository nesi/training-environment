# ansible

Install dependencies:

```
ansible-galaxy install -r requirements.yml
```

Copy example secrets file and edit:

```
cp vars/secrets.yml.example vars/secrets.yml
```

Copy ondemand config:

```
cp vars/ondemand-config.yml.example vars/ondemand-config.yml
```

and edit, in particular set `odic_settings.OIDCCryptoPassphrase` with a randomly
generated password, e.g. the output of `openssl rand -hex 40`.

Run:

```
ansible-playbook -i host.ini -u ubuntu --key-file ~/.ssh/flexi-private-key everything-except-ondemand.yml
ansible-playbook -i host.ini -u ubuntu --key-file ~/.ssh/flexi-private-key ondemand.yml
```

By default 2 users will be created, `training1` and `training2`. Passwords for these users will be
stored in the *users* sub-directory:

```
$ ls users/
password_training1.txt  password_training2.txt
```

More users can be added by overriding the `num_users_create` variable, e.g.

```
ansible-playbook -i host.ini -u ubuntu --key-file ~/.ssh/flexi-private-key \
    --extra-vars "num_users_create=5" everything-except-ondemand.yml
```

You will need to modify your hosts file with the IP addresses from *host.ini*, on Linux this file is
*/etc/hosts*, on Windows it is XXXX.

```
# /etc/hosts snippet

# this one should be the IP for web-node from host.ini
1.2.3.4 ood.flexi.nesi

# this one should be the IP for services-node from host.ini
5.6.7.8 ood-idp.flexi.nesi
```

Connect via [https://ood.flexi.nesi](https://ood.flexi.nesi).

## TODO

- starting jupyter app doesn't work
  - it is running and can proxy to it manually but it shows up as completed straight away in the dashboard with no link to open it
- lots of things hardcoded that should be made variables (keycloak dir location, urls, etc)
  - document which variables can be set
- run by terraform instead of manually?
