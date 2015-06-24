require 'oj'
require 'multi_json'

module NanoBox
  module Engine
    BUILD_DIR       = '/data'
    CODE_DIR        = "#{CODE_DIR}/code"
    DEPLOY_DIR      = '/mnt/deploy'
    CACHE_DIR       = '/mnt/cache'
    ENGINE_DIR      = '/opt/engines'
    SHARE_DIR       = '/share'
    CODE_LIVE_DIR   = "#{SHARE_DIR}/code"
    ENGINE_LIVE_DIR = "#{SHARE_DIR}/engines"
    ETC_DIR         = "#{BUILD_DIR}/etc"
    ENV_DIR         = "#{ETC_DIR}/environment.d"
    GONANO_PATH     = [
      CODE_DIR,
      "#{CODE_DIR}/bin",
      "#{BUILD_DIR}/sbin",
      "#{BUILD_DIR}/bin",
      '/opt/gonano/sbin',
      '/opt/gonano/bin',
      '/usr/local/sbin',
      '/usr/local/bin',
      '/usr/sbin',
      '/usr/bin',
      '/sbin',
      '/bin'
    ].join (':')

    # This payload will serialized as JSON and passed into each of the
    # engine scripts as the first and only argument. 
    def engine_payload

      data = {
        code_dir: CODE_DIR,
        build_dir: BUILD_DIR,
        cache_dir: CACHE_DIR,
        etc_dir: ETC_DIR,
        env_dir: ENV_DIR,
        app: payload[:app],
        env: payload[:env],
        dns: payload[:dns],
        port: payload[:port],
        boxfile: payload[:boxfile],
        engine: registry('engine')
      }

      ::MultiJson.dump(data)
    end

    # Detecting a filepath in this context is a bit tricky, as the filepath
    # likely will not match a local filepath since the filepath originates
    # from the development workstation. Rather, we are just looking for
    # characters at the beginning of the path that would generally indicate
    # a filepath, such as ~, ., /, and \.
    def is_filepath?(path)
      path =~ /^[~|\.|\/|\\]/
    end
  end
end
