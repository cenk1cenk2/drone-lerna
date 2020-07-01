FROM node:14-alpine

ADD . /release/

RUN yarn global add lerna \
  && apk update && apk add --no-cache --no-progress git && apk add --no-cache --no-progress bash

CMD ["/release/release.sh"]