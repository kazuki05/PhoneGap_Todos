## Installations

  * ###Xcode

    "Xcode->Preference->Downloads"から以下をインストールしてください。

    * Command Line Tools
    * IOS x.x Simulator

  * ###Homebrew

    	ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"

  * ###node

    	brew install node

  * ###PhoneGap

    	sudo npm install -g phonegap
    
    	phonegap -V install ios
    
    	brew install ios-sim
   
    もし "Error: No developer directory found at /Developer.Run /usr/bin/xcode-select to update the developer directory path."というエラーを見る場合、Developer フォルダーを設定するために以下を実行してください
 
    	sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
  
  * ###Yeoman

    	npm install -g yo grunt-cli bower


  * ###Sass

    	sudo gem install sass
    	sudo gem install compass

  * ###Google Chrome & LiveReload Extension

    "chrome://extensions/"を開き、"ファイルの URL へのアクセスを許可する"に、チェックを入れる。

## Run

  * ###Chrome

		$ cd path/to/myapp/www-source
		$ grunt watch
    
    Chromeを起動して、htmlのローカルパスを指定して開いてください。
    デベロッパーツールを開き、"Setting->Overrides"から、UserAgentを設定してください。

  * ###IOSシミュレーター

    	$ cd path/to/myapp/www-source
    	$ grunt
    	$ cd ../
    	$ phonegap local run ios