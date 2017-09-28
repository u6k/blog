FROM ruby AS blog-dev
MAINTAINER u6k.apps@gmail.com

# Setup locale
RUN apt-get update && \
    apt-get install -y locales && \
    apt-get clean && \
    echo "en_US UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Setup PlantUML
RUN apt-get install -y openjdk-7-jre graphviz && \
    apt-get clean

RUN wget -O /usr/lib/plantuml.jar http://sourceforge.net/projects/plantuml/files/plantuml.jar/download

COPY plantuml /usr/bin/plantuml
RUN chmod +x /usr/bin/plantuml

# Setup jekyll
RUN gem install jekyll bundler

# Generate HTML files
COPY . /var/my-blog
WORKDIR /var/my-blog
RUN bundle update && \
    jekyll build

FROM nginx:alpine
MAINTAINER u6k.apps@gmail.com

COPY --from=blog-dev /var/my-blog/_site/ /usr/share/nginx/html/
