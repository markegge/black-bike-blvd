# Making Targets Matter Demo App

A simple "proof of concept" app that's part of High Street's NCHRP ?? submittal. 


## Management Commands

Local host:

```bash
docker build -t targets .
docker tag targets meggehsc/targets:latest
docker push meggehsc/targets:latest
```

Remote Server:

```bash
sudo docker stop targets
sudo docker rm targets
sudo docker pull meggehsc/targets:latest
sudo docker run --publish 4010:3838 --detach --name bike --restart unless-stopped markegge/bike
```


## Server Config

Modify /etc/nginx/sites-enabled/default, adding an appropriate location block and proxy_pass directive:

```nginx
location /targets/ {
	proxy_pass http://localhost:4010/;
	rewrite ^/targets/(.*)$ /$1 break;
	proxy_redirect http://127.0.0.1:4010/ $scheme://$host/targets/;
	proxy_http_version 1.1;
	proxy_set_header Upgrade $http_upgrade;
	proxy_set_header Connection $connection_upgrade;
}
```

## Troubleshooting:

To connect to your Docker container:

`sudo docker exec -it targets bash`


If images do not display correctly, check the permissions on your local host. Files need to by 644 or greater.