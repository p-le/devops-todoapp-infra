kind: Deployment
apiVersion: apps/v1
metadata:
  name: ${component}
spec:
  replicas: 2
  selector:
    matchLabels:
      app: ${component}
  template:
    metadata:
      labels:
        app: ${component}
    spec:
      containers:
        - name: ${component}
          image: ${region}-docker.pkg.dev/${project_id}/${registry}/${image_name}:${image_tag}
          imagePullPolicy: Always
          ports:
            - containerPort: 80
      restartPolicy: Always
