FROM golang:1.23.4 as build

RUN mkdir -p /opt/app
COPY main.go /opt/app
COPY go.mod /opt/app
COPY go.sum /opt/app
# COPY vendor/ /opt/app/vendor/

WORKDIR "/opt/app"

RUN go build -o service

FROM gcr.io/distroless/base-debian12

WORKDIR /
COPY --from=build /opt/app/service /service
EXPOSE 80
CMD ["/service", "run"]
