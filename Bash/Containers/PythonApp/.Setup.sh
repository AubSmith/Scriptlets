sudo yum module install python39/build

mkdir firstpython && cd firstpython

# Test Python app locally
python3.9 -u web.py

# Browse to
# localhost:8000

# Build image
podman build -t pythonweb .

podman images

podman run --detach --publish 8000:8000 --name=helloweb localhost/pythonweb

curl http://localhost:8000

podman ps

podman stop helloweb
podman logs helloweb
podman rm helloweb
podman inspect localhost/pythonweb