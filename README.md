オレオレ WordPress 開発ベース
===========================

## 必要なもの

- PHP 任意
- MySQL 任意
- Composer
- WP-CLI
- bash などのシェル (cmd.exeはどうなんだろ?)

## ローカル開発

次のようにDBの準備をします。

```sql
CREATE USER wordpress@localhost IDENTIFIED BY 'wordpresspass';

CREATE DATABASE wpdemo;
GRANT ALL ON wpdemo.* TO wordpress@localhost;
```

`./init.sh` で本体やプラグインのダウンロード、初期設定をひととおり行います。

PHPビルトインサーバーだけで動きます。

```bash
wp server --host=0.0.0.0 --port=8000 --docroot=docroot
```

Apache で `.htaccess` を使いたい場合は、XAMPP 等の設定あわせて適宜スクリプト修正を。

やり直したいときは、DBを削除して `docroot` を消します。ごっそり消すと Git に削除 diff が出るので、
自分がバージョン管理しているテーマとプラグインだけ Git の履歴から元に戻し、再度 `./init.sh` します。

ライブラリ、プラグイン、テーマの追加は Composer で行い、つねに `composer.json` と `composer.lock` に
インストール状況を書き残しておきます。`docroot` を削除してもすぐに直前状態を確実に再現できます。

また、同じ理由で、管理画面で行った設定はできるだけ WP-CLI のコマンドとして書き残しておき、`init.sh` に追記します。

## デプロイの個人リハーサル

- Vagrant 1.8
- VirtualBox など

`vagrant up` で、MySQL に WordPress 用のデータベースを持ち、ドキュメントルートに素の WordPress を置いただけの Web サーバーが起動します。

`http://192.168.7.10/` にアクセスし、ブラウザから初期設定を行います。
(この初期設定が面倒な場合 `provisioning/scripts/setup-wordpress.sh` のコメントアウトを解除)

ここで、可能な限り本番からファイルやデータを取り込めると、リハとしてリアルになります。

SFTPで `./docroot` を `/var/www/html` にアップロードしてください。

- ホスト `192.168.7.10:22`
- ユーザー `vagrant`
- パスワード `vagrant`

サーバーで起こったファイル変化をローカルと比較、必要であればダウンロードしてください。
こういうとき PhpStorm(IntelliJ IDEA) の Sync With Local... 機能が便利です。

注: `wp-config` をアップロードしてしまわないよう、同期の対象から外すように。

やり直したいときは `vagrant destroy` で最初から。

## 自動テスト

Chromeで受け入れテストをしたいので、追加でSeleniumを導入します。

- selenium-server-standalone
- chromedriver

Homebrew があれば簡単にこれで:

```bash
brew install selenium-server-standalone chromedriver
selenium-server -p 4444
```

(Macでしか確認していません。他のOSではそれぞれの方法で適宜インストールしてください)

テスト用のDBを追加します。FunctionalとIntegrationではここにDBダンプを流し込むようです。

```sql
CREATE DATABASE `wpdemo-tests`;
GRANT ALL ON `wpdemo-tests`.* TO wordpress@localhost;
```

Codeceptionヘルパーの生成 (モジュールを追加/削除したら要再実行)

```bash
docroot/vendor/bin/wpcept build
```

実行

```bash
docroot/vendor/bin/wpcept run                            #すべて
docroot/vendor/bin/wpcept run acceptance                 #acceptance のみ
docroot/vendor/bin/wpcept run acceptance HelloWorldCept  #acceptance/HelloWorldCept のみ
```

新規テストスクリプトの生成
```bash
docroot/vendor/bin/wpcept generate:cept acceptance Hoge
```
