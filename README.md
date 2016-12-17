GitHub Pages 用 jekyll 実行環境
==============================

GitHub Pages 用に、 [jekyll](http://jekyllrb.com/) の実行環境を作成します。  
初回起動時には、 [kickster](http://kickster.nielsenramon.com/) を使って
テンプレートをセットアップし、画像圧縮のために gulp imagemin も追加しています。  

テンプレートには、CircleCI用の設定ファイルも含まれているので、CircleCIに連携して、
すぐに、自動デプロイを構成することもできます。  

## 起動方法
環境は、vagrant で起動するか、docker-compose で起動してください。  
vagrant で起動した場合は、その中で、docker-compose が実行されます。  
動作確認は、Windows で vagrant を使って行われています。  
Windows で vagrant を使う場合は、 次のとおり、vagrant-winnfsd を
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

jekyll は、```--watch --incremental --force_polling``` オプションで
起動しているので、リソースを編集すると、自動的に変換されます。  
ただし、 vagrant の synced_folder の遅延か、 watch のポーリング間隔の問題か、
変換されるまでの反応が悪いことがあります。

### jekyll serve 手動起動
リソースにエラーがあると、 jekyll serve がエラーで終了し、dockerのコンテナも終了します。  
コンテナを jekyll serve で起動する前に、 jekyll build を実行して、エラーの有無が
ターミナルに流れるようにしてあります。
自動起動していない場合は、ターミナルに出力されたログを確認してください。  
また、次のように、コンテナを再起動することでも、ログを確認できます。  
vagrantで起動した場合を例示します。  
```
cd /vagrant
docker-compose up
```
コンテナが正常に自動起動されていると、編集作業中のビルドログを見ることができません。  
ターミナルにログを流しながら、コーディングしたい場合も、一旦コンテナを止めて、
ターミナルから、再起動します。  
```
cd /vagrant
docker-compose down
docker-compose up
```

### 手動でビルドする
--watch の反応が悪くて、まどろっこしい場合は、コンテナにアタッチして、
手動で build もできます。  
```
docker exec -it jekyll-boot jekyll build
```

## 用途
このリポジトリは、あくまで、 jekyll が実行できる環境を作ることが目的です。  
初回起動して、 ~/jekyll  の中に、テンプレートが作成されたら、対象サイトのための
リソースは、 ~/jekyll の中で、 ```git init``` して、別のリポジトリで、
管理してください。  
CircleCI も、そのリポジトリで、連携してください。

## CircleCI の自動デプロイ
~/jekyll/ にある circle.yml と bin/automated は、 CircleCI の設定と
自動デプロイのためのスクリプトです。  
このスクリプトは、以下の git のブランチで構成されていることを期待します。  

| ブランチ | 説明 |
|:-------:|------|
| master  | ビルドされたコンテンツがコミットされたブランチ |
| draft   | jekyllのテンプレート |

draft ブランチで、 jekyll 用のリソース全般を管理し、 jekyll によって、
変換されて、最終的にWEBページとして公開される静的ファイルは、 master ブランチです。  
2つのブランチで、それぞれ、異なるファイルを管理します。

## 最初にやること
コンテナが起動して、 ~/jekyll が作成されたあとは、まずは、次のことをやってください。  

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

* リポジトリにプッシュ  
github にリポジトリを作成して、 ~/jekyll をプッシュする。  
```
cd ~/jekyll
git init
git remote add origin ${ORIGIN_URL}
# master ブランチをプッシュ
echo "coming-soon" > README.txt
git add README.txt
git commit -m "first commit"
git push origin master
rm README.txt
# draft ブランチをプッシュ
git checkout -b draft
git add -A
git commit -m "first commit"
git push origin draft
```

## CircleCIとの連携

### Integrationの設定  
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
|Title|CircleCI 書き込み  (※なんでもよい) |
|Key  |ssh-keygenで作成した id_rsa.sample.pub の内容を貼り付ける|
|Allow write access| チェック （必須） |
   
### CircleCI への秘密キーの登録
https://circleci.com/gh/アカウント/リポジトリ名/edit#ssh
「Add SSH Key」ボタンを押して、次のように登録する。 

| 項目 |値|
|:-----:|:-----|
|Hostname|github.com|
|Private Key|ssh-keygenで作成した id_rsa.sample の内容を貼り付ける|

## 自動デプロイ
以上の設定を行うと、 draft ブランチにプッシュする毎、CircleCI で jekyll が実行されて
変換結果を master ブランチにデプロイされて、GitHub Pages で公開されているWEBサイトが
自動的に更新されます。  


