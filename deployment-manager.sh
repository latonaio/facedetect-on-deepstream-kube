#!/bin/bash

action=$1

case "$action" in
apply|delete)
;;
*)
  echo "usage: $0 [action: apply | delete]"
  exit 1
;;
esac

if [ $action = "apply" ]; then
  xhost +
fi

kubectl "$action" -f <(cat <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    run: facedetect-on-deepstream
  name: facedetect-on-deepstream
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      run: facedetect-on-deepstream
  template:
    metadata:
      labels:
        run: facedetect-on-deepstream
    spec:
      hostname: facedetect-on-deepstream
      hostNetwork: true
      containers:
      - name: facedetect-on-deepstream
        image: latonaio/facedetect-on-deepstream:latest
        imagePullPolicy: IfNotPresent
        command: ["deepstream-app"]
        args: ["-c", "/app/src/deepstream_app_source1_facedetect.txt"]
        env:
        - name: DISPLAY
          value: "$DISPLAY"
        volumeMounts:
        - mountPath: /app/src
          name: current-dir
        - mountPath: /tmp/.X11-unix
          name: x11-dir
        - mountPath: /dev
          name: dev-dir
        securityContext:
          privileged: true
      volumes:
      - name: current-dir
        hostPath:
          path: "$PWD"
          type: Directory
      - name: x11-dir
        hostPath:
          path: /tmp/.X11-unix
          type: Directory
      - name: dev-dir
        hostPath:
          path: /dev
          type: Directory
---
apiVersion: v1
kind: Service
metadata:
  labels:
    run: facedetect-on-deepstream
  name: facedetect-on-deepstream
  namespace: default
spec:
  selector:
    run: facedetect-on-deepstream
  type: ClusterIP
  ports:
    - port: 12345
      protocol: TCP
      targetPort: 12345
EOF
)
