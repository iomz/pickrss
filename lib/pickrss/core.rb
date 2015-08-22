module PickRSS
  module Core
    def config
      @config ||= {}
    end

    def load_config
      YAML.load_file(File.expand_path('../../../config.yml', __FILE__)).each{ |k,v| config[k.to_sym] = v }
    end

    def pick(feed_uri)
      PickRSS::RSSHandler.process_feed(feed_uri)
    end
  end

  extend Core
  PickRSS.load_config
end

