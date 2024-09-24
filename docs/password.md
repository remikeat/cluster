# Password

### How to encode in base64

```
echo -n "username:password" | base64
```

### How to create htpasswd data

```
htpasswd -n username
```

### How to create password hash

```
openssl passwd -6 password
```
