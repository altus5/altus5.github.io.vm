GitHub Pages 用 jekyll & kickster 実行環境
=========================================

GitHub Pages 用に、 [jekyll](http://jekyllrb.com/) の実行環境を、[kickster](http://kickster.nielsenramon.com/) のテンプレートでセットアップし、
画像圧縮のために gulp imagemin を追加しています。  

また、テンプレートには、CircleCI用の設定ファイルもあるので、作成されたサイトのデータを
GitHub Pages 用のリポジトリにプッシュして、CircleCIに連携すると、自動的にデプロイされます。  

## 起動方法
環境は、vagrant で起動するか、docker-compose で起動してください。  
vagrant で起動した場合は、その中で、docker-compose が実行されます。  
windows で vagrant を使う場合は、 次のとおり、vagrant-winnfsd を
インストールしてください。  
```
vagrant plugin install vagrant-winnfsd
```
コンテナは、 jekyll を  ~/jekyll  ディレクトリの中で実行します。  
jekyll で変換するリソースが既にある場合は、 ~/jekyll  に配置してから、
起動してください。  
これから、新規に作成する場合は、~/jekyll  ディレクトリは作成しないで、
そのまま、起動してください。  
コンテナの初回起動時に、 ~/jekyll のディレクトリを作成し、
[kickster](http://kickster.nielsenramon.com/) のテンプレートを展開します。  
kickster のテンプレートは、手を加えていない素の状態だと、favicon だけ
 kickster のアイコンで、その他は、内容が空っぽの真っ白な表示です。
オレンジ色のロケットのfaviconになっていれば、正常起動しています。  

## jekyll serve
コンテナが起動すると、 jekyll serve が実行された状態になります。  
vagrant で起動した場合は、ブラウザで、 http://192.168.98.10:4000 に
アクセスすると、 ~/jekyll にあるリソースが、表示されます。   
注意点として、特に初回の起動では、kickster のテンプレートの展開や、
build 処理が実行されるので、ブラウザでアクセス可能になるまで、少し時間がかかります。

jekyll は、```--watch --incremental --force_polling``` オプションで
起動しているので、リソースを編集すると、自動的に変換されます。  
ただし、 watch のポーリング間隔が長めのようで、変換されるのに、10秒くらい
かかる場合があるようです。  

### jekyll serve 手動起動
リソースにエラーがあると、 jekyll serve がエラーで終了し、dockerのコンテナも終了します。  
ブラウザでアクセスして接続されなかった場合は、docker ps でコンテナが起動しているか確認してみてください。  
自動起動していない場合は、次のように、dockerコンテナを起動してみて、ターミナルに流れる、ログを確認してください。  
vagrantで起動した場合を例示します。  
```
cd /vagrant
docker-compose up
```
また、自動起動がエラーなく実行されたとしても、そのあとの編集作業中の自動ビルドでのログを見ることができません。  
ターミナルにログを流しながら、コーディングしたい場合は、一旦コンテナを止めて、
ターミナルから、再起動します。  
vagrantで起動した場合を例示します。  
```
cd /vagrant
docker-compose down
docker-compose up
```

### 手動でビルドする
--watch のポーリングが遅くて、まどろっこしい場合は、コンテナにアタッチして、
手動で build もできます。  
```
docker exec -it kickster jekyll build
```

## 用途
このリポジトリは、あくまで、kickster と jekyll が実行できる環境です。  
初回起動して、 ~/jekyll  の中に、テンプレートが作成されたら、対象サイトのための
リソースは、 ~/jekyll の中で、 ```git init``` して、別のリポジトリで、
管理してください。  
CircleCI も、そのリポジトリで、連携してください。

## 最初にやること
~/jekyll が作成されたあとは、まずは、次のことをやってください。  
* _config.yml  
次の行を、正しいサイト名に変更する。  
```
name: my_awesome_site
```
* bower.json  
次の行を、正しいサイト名に変更する。（必須ではない）  
```
"name": "my_awesome_site",
```
* README.md  
これも必須ではないものの、編集しておいてよいかと。
* circle.yml  
次の行を、githubのアカウントで設定する。（CircleCIを使う場合は必須）  
```
USER_NAME: <your-github-username>
USER_EMAIL: <your-github-email>
```

## CircleCIとの連携

### Integrationの設定  
* ~/jekyll の中身を github のリポジトリにプッシュ  
* githubの画面の右上のアイコンのプルダウンから、Integrations を選択  
* CircleCI をクリック  
* 画面に従って設定

初期状態では、CircleCIは、リポジトリに対して、プッシュすることができないので、
書き込み権限のあるSSHのキーを登録する。  

### SSHキーの作成  
ローカルで、SSHのキーを作成する  
例)
```
ssh-keygen -t rsa -N "" -f id_rsa.sample
```

### github への公開キーの登録  
https://github.com/アカウント/リポジトリ名/settings/keys  
Integrations の設定で、CircleCIの方でも、このリポジトリを選択していたら、
すでに、CircleCIの登録があるハズだが、これは、読み取り専用なので、
「Add deploy key」ボタンを押して、次のように登録する。  

| 項目 |値|
|:-----:|:-----|
|Title|CircleCI 書き込み (なんでもよい) |
|Key  |ssh-keygenで作成した id_rsa.sample.pub の内容を貼り付ける|
   
### CircleCI への秘密キーの登録
https://circleci.com/gh/アカウント/リポジトリ名/edit#ssh
「Add SSH Key」ボタンを押して、次のように登録する。 

| 項目 |値|
|:-----:|:-----|
|Hostname|github.com|
|Private Key|ssh-keygenで作成した id_rsa.sample の内容を貼り付ける|

