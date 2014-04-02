module RelateIQ
  class Contact < APIResource

    def self.find(id, params = {})
      instance = self.new(id)
      params.merge!(addressBookId: id)
      response = RelateIQ.get('contacts', params)
      instance.refresh_from(response)
      instance
    end

  end
end
