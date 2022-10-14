# CHANGELOG
### 0.7.0 - 2022-10-14
- Change whitelist/blacklist, to allowlist/denylist but maintain backwards
    compatibility

### 0.6.1 - 2021-08-02
- Update required ruby version to at least 2.7

### 0.6.0 - 2021-08-02
- Update required ruby version to 2.7

### 0.5.1 - 2016-11-11
- Add hotfix for putter running on a script in a local directory to print out the file information

### 0.5.0 - 2016-11-10
- Add methods blacklist to the configuration options
- Ensures that local method options override anything in the blacklist

### 0.4.1 - 2016-10-16
- By default, Putter will not run in production mode in Rails, this can be allow via configuration
- By default, Putter will ignore methods from ActiveRecord::Base if it is present
- Do not re-define a method if it is whitelisted
- Code cleanup and README updates

### 0.4.0 - 2016-08-18
- Add methods option to `Putter.watch`
- Refactor watch method to use registry
- Refactor method creation specs
- Update README

### 0.3.0 - 2016-07-08
- Add `Putter.watch` ability to watch a class and instances created by that class

### 0.2.1 - 2016-06-08
- Add missing Gemfile.lock to bundled gem.

### 0.2.0 - 2016-06-04
- Convert print strategies to a single print strategy for both methods calls and results and adjust configuration accordingly.

### 0.1.1 - 2016-05-29
- Fix print strategy to put new line before debugging statements to not have a break between method calls and results.

### 0.1.0 - 2016-05-29
- Initial commit, see README.
