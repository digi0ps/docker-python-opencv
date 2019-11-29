# Python OpenCV Docker Image

Docker Image with Python 3.6 and OpenCV 3.3.0.

## Running it
```
docker run -it digi0ps/python-opencv
>>> import cv2
```

## Using as Base
```
FROM digi0ps/python-opencv
RUN ...
```

## Tags
- `latest`

## TODO
- [ ] Use alpine.
- [ ] Reduce final image size.