# Vaultwarden

## Setup

From this directory, run:

```bash
./vaultwarden.setup.sh
```

## Start Vaultwarden

After running the setup script, start the Quadlet:

```
systemctl --user daemon-reload
systemctl --user enable --now vaultwarden.service
```

Check that it is running:

```
systemctl --user status vaultwarden.service
```

Vaultwarden should then be available at:

```
http://192.168.0.2:8080
```

## Create your Vaultwarden account

Open the Vaultwarden address in a web browser:

```
http://192.168.0.2:8080
```

Select **Create account** and enter your email address and a strong master password.

The master password is used to encrypt your vault. Vaultwarden does not know your master password, so it cannot be recovered if it is lost.

Once the account has been created, sign in normally.

After creating the account, registration should be disabled unless you specifically want other people to be able to register. Change:

```
SIGNUPS_ALLOWED=false
```

in `vaultwarden.env`, then restart Vaultwarden:

```
systemctl --user restart vaultwarden.service
```

## Connect a Bitwarden client

Vaultwarden uses the same client protocol as Bitwarden, so you use the official Bitwarden clients to connect.

Install the Bitwarden client on your device and open its server settings.

Set the **Server URL** to:

```
http://192.168.0.2:8080
```

Then sign in using the Vaultwarden account you created above.

The same server URL can be used from other devices on the same network.

### Browser extension

For the Bitwarden browser extension:

1. Open the extension.
2. Open **Settings**.
3. Find **Server URL** or **Self-hosted**.
4. Enter:
   
   ```
   http://192.168.0.2:8080
   ```
5. Save the server setting.
6. Sign in with your Vaultwarden account.

### Desktop and mobile clients

The same principle applies to the Bitwarden desktop and mobile applications: configure the self-hosted server URL before signing in.

Use:

```
http://192.168.0.2:8080
```

## Admin interface

Vaultwarden's administration interface is available at:

```
http://192.168.0.2:8080/admin
```

The admin password is the plaintext password that was entered when `setup.sh` generated the `ADMIN_TOKEN` hash.

The plaintext password is **not** stored in the configuration. Only its Argon2 hash is stored in `vaultwarden.env`.

## Persistent data

Vaultwarden stores its persistent application data in:

```
./data/
```

This directory must be preserved. It contains the Vaultwarden database and other persistent application state.

It is excluded from Git.

## Configuration

Deployment configuration is stored in:

```
vaultwarden.env
```

The committed template is:

```
vaultwarden.env.example
```

Do not commit `vaultwarden.env`. It contains the administrator authentication secret.
