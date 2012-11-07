# Bropbox-iOS

##Requirement 

**Command Line Tools 설치**

Xcode - Perferences - Downloads - Command Line Tools가 installed 상태인지 확인해주세요. 
<br>
## Install
Baas.io-SDK-iOS는 git의 submodules로 구성 되어 있습니다. SoruceTree 같은 툴을 이용할 경우 자동적으로 submodule을 인식하나, zip으로 다운 받은 경우 폴더 안에 있는 아래 스크립트를 실행해주세요.

	# cd baas.io-SDK-iOS
	# ./submodule_setup.sh	


또는 터미널에서 clone 할때는 아래와 같이 받으시면 submodule이 정상적으로 다운 됩니다.


	# git clone --recursive git://github.com/kthcorp/baas.io-SDK-iOS.git

zip으로 다운 받으신 경우에는 아래 스크립트만 실행해 주시면 됩니다.

## Build
일부 Xcode 버전에서 첫번째 빌드에서 header 파일을 못 찾는 버그가 있습니다. 컴파일 에러 발생 시 Project를 Clean(Shift+Cmd+K)하고 다시 Build(Cmd+R)하면 됩니다.
