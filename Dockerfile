# 1
FROM vapor/swift:5.1-bionic
# 2
WORKDIR /package
# 3
COPY . ./
# 4
RUN swift package resolve
RUN swift package clean
# 5
#RUN swift test --enable-test-discovery
CMD ["swift", "test", "--enable-test-discovery"]
