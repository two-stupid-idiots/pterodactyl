server {
	listen 80;
	listen [::]:80;
	server_name wings.example.com;

	location / {
	return 301 https://wings.example.com$request_uri;
	}

	location ^~ /.well-known/acme-challenge {
		alias /var/lib/dehydrated/acme-challenges;
	}
}

server {
	listen 443 ssl;
	listen [::]:443 ssl;
	server_name wings.example.com;

	ssl_certificate /var/lib/dehydrated/certs/wings.example.com/fullchain.pem;
	ssl_certificate_key /var/lib/dehydrated/certs/wings.example.com/privkey.pem;

	location / {
		proxy_pass http://127.0.0.1:8443;
		proxy_set_header Host $host;
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;

		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "upgrade";
	}
	client_max_body_size 100M;
}
