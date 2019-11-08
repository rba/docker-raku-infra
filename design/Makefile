IMAGE:=design.raku.org

build:
		docker build -t ${IMAGE} .

run:
		docker run -d -p 80:3000 ${IMAGE}

clean:
		docker rmi ${IMAGE}
