FROM ruby:2.5
LABEL maintainer="u6k.apps@gmail.com"

# Import file
COPY plantuml /usr/bin/plantuml
COPY Gemfile /var/my-blog/Gemfile

WORKDIR /var/my-blog/

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
    bundle update

# Setup container config
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

CMD ["jekyll", "build", "--increment"]
