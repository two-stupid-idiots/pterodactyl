server {
	listen 80;
	listen [::]:80;
	server_name panel.example.com;

	location / {
	return 301 https://panel.example.com$request_uri;
	}

	location ^~ /.well-known/acme-challenge {
		alias /var/lib/dehydrated/acme-challenges;
	}
}

server {
	listen 443 ssl;
	listen [::]:443 ssl;
	server_name panel.example.com;

	ssl_certificate /var/lib/dehydrated/certs/panel.example.com/fullchain.pem;
	ssl_certificate_key /var/lib/dehydrated/certs/panel.example.com/privkey.pem;

	location / {
		proxy_pass http://127.0.0.1:8080;
		proxy_set_header Host $host;
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;
	}
	client_max_body_size 100M;
}
