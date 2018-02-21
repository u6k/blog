FROM ruby AS blog-dev

# Import file
COPY plantuml /usr/bin/plantuml
COPY Gemfile /tmp/Gemfile

# Setup software
RUN apt-get update && \
    apt-get upgrade -y && \
    # Install locales, OpenJDK, Graphviz
    apt-get install -y \
        locales \
        openjdk-8-jre \
        graphviz && \
    apt-get clean && \
    # Setup locale
    echo "en_US UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    # Install PlantUML
    wget -O /usr/lib/plantuml.jar http://sourceforge.net/projects/plantuml/files/plantuml.jar/download && \
    chmod +x /usr/bin/plantuml && \
    # Setup jekyll
    gem install \
        jekyll \
        bundler && \
    cd /tmp && \
    bundle update

# Setup run
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# Generate HTML files
COPY . /var/my-blog
WORKDIR /var/my-blog
RUN jekyll build

FROM nginx
LABEL maintainer="u6k.apps@gmail.com"

COPY --from=blog-dev /var/my-blog/_site/ /usr/share/nginx/html/
