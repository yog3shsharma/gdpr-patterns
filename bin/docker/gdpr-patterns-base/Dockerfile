FROM    node-hugo

RUN     git clone https://github.com/pbx-gs/gdpr-patterns.git
WORKDIR gdpr-patterns
RUN     sed -ie 's/git@github.com:/https:\/\/github.com\//' .gitmodules
#RUN     git rm --cached coreui-hugo             && \
RUN     git submodule init                      && \
        git submodule update                    && \
        npm install