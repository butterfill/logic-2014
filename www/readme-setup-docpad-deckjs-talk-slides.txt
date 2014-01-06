1. copy the files in this directory into a new blank directory where you want to create the slides.


2. run:

npm install

(this installs the dependencies from package.json)


3. create:

docpad generate


3b. [optional] to update local version docpad and plugins (CAUTION: may not work)

docpad update


3c. You may also get the latest deck.core.js (but don't upgrade deck.core.css)


4. serve

cd out/
serve.sh
(i.e. python -m SimpleHTTPServer 8080)


5. upload specifying ***SUBDOMAIN***

s3cmd sync --delete-removed out/ s3://origins-of-mind.butterfill.com/***SUBDOMAIN*** --add-header "Cache-Control: max-age=86400"


6. nb for watching

docpad watch

6b sometimes generates 	EMFILE error, in that case:

ulimit -n 8192

