# metadata-qa-ddb-web
Web interface for DDB metadata quality assessment

```
sudo apt-get install php-intl php-sqlite3 php-mysql
```

```bash
export SMARTY_VERSION=3.1.33
cd libs/
curl -s -L https://github.com/smarty-php/smarty/archive/v${SMARTY_VERSION}.zip --output v$SMARTY_VERSION.zip
unzip -q v${SMARTY_VERSION}.zip
rm v${SMARTY_VERSION}.zip
mkdir -p _smarty/templates_c
chmod a+w -R _smarty/templates_c/
cd ..
```
