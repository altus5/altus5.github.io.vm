jekyll & kickster 実行環境
=========================

[jekyll](http://jekyllrb.com/) の実行環境を、[kickster](https://github.com/nielsenramon/kickster) のテンプレートでセットアップします。  

## 起動方法
環境は、vagrant で起動するか、docker-compose で起動してください。  
vagrant で起動した場合は、その中で、docker-compose が実行されます。  
windows で vagrant を使う場合は、 次のとおり、vagrant-winnfsd を  
インストールしてください。  
```
vagrant plugin install vagrant-winnfsd
```
コンテナは、 jekyll を  ~/jekyll  ディレクトリの中で実行します。  
jekyll で変換するソースコードが既にある場合は、 ~/jekyll  に配置してください。  
尚、初回起動時に、 ~/jekyll  に何もリソースがない場合、
[kickster](https://github.com/nielsenramon/kickster) で作成された  
テンプレートをコピーするので、とりあえず、動かしみるなら、何も配置しないで、  
そのまま起動してみてください。

## jekyll serve
コンテナが起動すると、 jekyll serve が実行された状態になります。  
vagrant で起動した場合は、ブラウザで、 http://192.168.98.10:4000 に
アクセスすると、  
~/jekyll にあるリソースが、静的変換されて、表示されます。   
ちなみに、kicksterのテンプレートは、手を加えていない素の状態だと、favicon だけ  
 kickster のアイコンで、その他は、内容が空っぽの真っ白な表示です。  
オレンジ色のロケットのfaviconになっていれば、正常起動しています。  

jekyll は、```--watch --incremental --force_polling``` オプションで
起動しているので、  
リソースを編集すると、自動的に変換されます。  
ただし、 watch のポーリング間隔が長めのようで、変換されるのに、10秒くらい  
かかる場合があるようです。  
手動で、 build を実行したい場合は、docker コンテナで build を実行してください。  
```
docker exec -it kickster jekyll build
```

## 用途
このリポジトリは、あくまで、kickster と jekyll が実行できる環境です。  
初回起動して、 ~/jekyll  の中に、テンプレートが作成されたら、対象サイトのための  
ソースコードは、 ~/jekyll の中で、 ```git init``` して、別のリポジトリで、
管理してください。  
CircleCIも、そのリポジトリで、連携してください。

