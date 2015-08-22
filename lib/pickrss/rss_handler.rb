module PickRSS
  class RSSHandler
    def self.process_feed(feed_uri)
      @doc = filter(get_xml(feed_uri))
      fix_feed(@doc, feed_uri)
    end

    def self.get_xml(feed_uri)
      Nokogiri::XML(open(feed_uri).read)
    end

    def self.filter(doc)
      doc.xpath('//xmlns:item/xmlns:title').each { |node|
        if node.text =~ /PR:/i
          node.parent.remove
        end
      }
      doc.to_xml
    end

    def self.fix_feed(doc, feed_uri)
      newdoc = ""
      doc.each_line do |line|
        if line =~ /href="\.\.\//
          line.scan(/href="(\.\.\/[^"]*)/).each do |pat|
            relative_path = pat.first
            fixed_uri = fix_relative_path(feed_uri, relative_path)
            line.sub!(relative_path, fixed_uri)
          end
          newdoc += line
        else
          newdoc += line
        end
      end
      newdoc
    end

    def self.fix_relative_path(feed_uri, relative_path)
      feed_file = File.basename(URI(feed_uri).path)
      feed_uri.slice!(feed_file)
      URI.join(feed_uri, relative_path).to_s
    end

  end
end

