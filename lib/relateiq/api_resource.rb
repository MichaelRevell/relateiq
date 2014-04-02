module RelateIQ
  class APIResource < RiqObject
    def self.name
      n = self.to_s.split('::')[-1]
      # Hyphenize
      n.scan(/([A-Z][a-z]*)/).join('-').downcase
    end

    def name
      n = self.class.to_s.split('::')[-1]
      # Hyphenize
      n.scan(/([A-Z][a-z]*)/).join('-').downcase
    end

    def self.find(id, params = {}, url = nil)
      path = url.nil? ? "#{name}s/#{id}" : url
      instance = self.new(id)
      response = RelateIQ.get(path, params)
      instance.refresh_from(response)
      instance
    end

    def self.all(params = {}, url = nil)
      params = {} unless params.is_a? Hash
      plural = "#{name}s"
      path = url.nil? ? "#{plural}" : url
      response = RelateIQ.get(path, params)
      objects = response['objects'] || []
      list = Array.new
      objects.each do |v|
        if v.class == Hash && v['id'].nil?
          c = self.new(v['id'])
        else
          c = self.new
        end
        c.refresh_from(v)
        list.push(c)
      end
      return RiqList.new(list)
    end

    def update(params = {})
      path = "#{self.name}s/#{self.id}"
      p = { self.name => params }.to_json
      response = RelateIQ.put(path, p)
    end

    def self.update(id, params = {})
      plural = "#{name}s"
      path = "#{plural}/#{id}"
      p = { self.name => params }.to_json
      response = RelateIQ.put(path, p)
    end


    def create(params = {})
      plural = "#{name}s"
      path = "#{plural}/#{self.id}"
      p = { self.name => params }.to_json
      resonse = RelateIQ.post(path, p)
    end

    def delete(params = {})
      plural = "#{name}s"
      path = "#{plural}/#{self.id}"
      RelateIQ.delete(path)
    end

    def self.delete(id, params = {})
      plural = "#{name}s"
      path = "#{plural}/#{id}"
      RelateIQ.delete(path)
    end
  end
end

