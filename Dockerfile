FROM jekyll/builder as builder
ENV JEKYLL_UID=1000
ENV JEKYLL_GID=1000
ENV VERBOSE=true
ENV JEKYLL_DEBUG=true
#COPY --from=bundler /srv/jekyll/ /srv/jekyll
#COPY --from=bundler /usr/local/bundle/ /usr/local/bundle
COPY . /srv/jekyll 
WORKDIR /srv/jekyll
RUN cd /srv/jekyll \
       && chown -R jekyll.jekyll /srv/jekyll \
       && ls -la /srv/jekyll \
       && /usr/jekyll/bin/entrypoint bundle update \
       && /usr/jekyll/bin/entrypoint jekyll build -s /srv/jekyll -d /srv/jekyll/_site \
       && mkdir /data \
       && cp -av /srv/jekyll/* /data \      
       && cp -av /srv/jekyll/.??* /data
   
       
FROM nginx:stable-alpine
COPY --from=builder /data/ /var/www/mazacoin.org/
COPY ./nginx/default-backend.conf /etc/nginx/sites-enabled/default.conf
RUN  rm /etc/nginx/conf.d/default.conf \
      && sed -i '32i\\    include /etc/nginx/sites-enabled/*.conf\;' /etc/nginx/nginx.conf
RUN  chown -R nginx /var/www/mazacoin.org
