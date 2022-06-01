# Self-Documented Makefile
# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

docker-build: ## Docker imageを作る
	docker-compose -f docker-compose.yaml build
docker-run: ## Docker ストリーミング用コンテナを建てる
	docker-compose -f docker-compose.yaml up -d
stream-start: ## ストリーミングを開始する
	xhost +
	docker exec -it deepstream-facedetect deepstream-app -c /app/src/deepstream_app_source1_facedetect.txt
docker-login: ## ストリーミングコンテナにログイン
	docker exec -it deepstream-facedetect bash
pod-start: ## kubernetesのpodを開始する
	bash ./deployment-manager.sh apply
pod-stop: ## kubernetesのpodを停止させる
	bash ./deployment-manager.sh delete   
