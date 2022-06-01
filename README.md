# facedetect-on-deepstream-kube
facedetect-on-deepstream-kube は、DeepStream 上で FaceDetect の AIモデル を動作させるマイクロサービスです。  

## 動作環境
- NVIDIA 
    - DeepStream
- FaceDetect
- Docker
- Kubernetes or Docker Compose
- TensorRT Runtime

## FaceDetectについて
FaceDetect は、画像内の人の顔を検出し、カテゴリラベルを返すAIモデルです。  

## 動作手順
### Docker imageの作成
Makefileに記載された以下のコマンドにより、FaceDetect の Docker image を作成します。
```
docker-build:
        docker-compose -f docker-compose.yaml build
```

### Kubernetes の場合

#### kubernetesのpodを開始する
Makefile に記載された以下のコマンドにより、DeepStream 上の FaceDetect でストリー
ミングを開始します。
```
pod-start: ## kubernetesのpodを開始する
        bash ./deployment-manager.sh apply
```
#### kubernetesのpodを停止させる
Makefile に記載された以下のコマンドにより、DeepStream 上の FaceDetect でのストリーミングを停止させます。
```
pod-stop: ## kubernetesのpodを停止させます。
        bash ./deployment-manager.sh delete
```

### Docker Compose の場合

#### Dockerコンテナの起動
Makefile に記載された以下のコマンドにより、FaceDetect の Dockerコンテナ を起動します。
```
docker-run: 
	docker-compose -f docker-compose.yaml up -d
```
#### ストリーミングの開始
Makefile に記載された以下のコマンドにより、DeepStream 上の FaceDetect でストリーミングを開始します。  
```
stream-start: ## ストリーミングを開始する
	xhost +
	docker exec -it deepstream-facedetect deepstream-app -c /app/src/deepstream_app_source1_facedetect.txt
```

## 相互依存関係にあるマイクロサービス  
本マイクロサービスを実行するために FaceDetect の AIモデルを最適化する手順は、[facedetect-on-tao-toolkit](https://github.com/latonaio/facedetect-on-tao-toolkit)を参照してください。  


## engineファイルについて
engineファイルである facedetect.engine は、[facedetect-on-tao-toolkit](https://github.com/latonaio/facedetect-on-tao-toolkit)と共通のファイルであり、当該レポジトリで作成した engineファイルを、本リポジトリで使用しています。  
