module CASClient

  # Represents a response from the CAS server to a 'validate' request
  # (i.e. after validating a service/proxy ticket).
  class ValidationResponse
    include XmlResponse

    attr_reader :protocol, :user, :pgt_iou, :proxies, :extra_attributes

    def initialize(raw_text, options={})
      parse(raw_text, options)
    end

    def parse(raw_text, options)
      raise BadResponseException,
            "CAS response is empty/blank." if raw_text.to_s.empty?
      @parse_datetime = Time.now
      if raw_text =~ /^(yes|no)\n(.*?)\n$/m
        @protocol = 1.0
        @valid = $~[1] == 'yes'
        @user = $~[2]
        return
      end

      @xml = check_and_parse_xml(raw_text)

      # if we got this far then we've got a valid XML response, so we're doing CAS 2.0
      @protocol = 2.0

      if is_success?
        cas_user = @xml.elements["cas:user"]
        @user = cas_user.text.strip if cas_user
        @pgt_iou = @xml.elements["cas:proxyGrantingTicket"].text.strip if @xml.elements["cas:proxyGrantingTicket"]

        proxy_els = @xml.elements.to_a('//cas:authenticationSuccess/cas:proxies/cas:proxy')
        if proxy_els.size > 0
          @proxies = []
          proxy_els.each do |el|
            @proxies << el.text
          end
        end

        @extra_attributes = {}
        @xml.elements.to_a('//cas:authenticationSuccess/cas:attributes/* | //cas:authenticationSuccess/*[local-name() != \'proxies\' and local-name() != \'proxyGrantingTicket\' and local-name() != \'user\' and local-name() != \'attributes\']').each do |el|
          inner_text = el.cdatas.length > 0 ? el.cdatas.join('') : el.text
          name = el.name
          unless (attrs = el.attributes).empty?
            name = attrs['name']
            inner_text = attrs['value']
          end
          @extra_attributes.merge! name => inner_text
        end

        # unserialize extra attributes
        @extra_attributes.each do |k, v|
          if k=='nickname'
            @extra_attributes[k] = v
          else
            @extra_attributes[k] = parse_extra_attribute_value(v, options[:encode_extra_attributes_as])
          end
        end
      elsif is_failure?
        @failure_code = @xml.elements['//cas:authenticationFailure'].attributes['code']
        @failure_message = @xml.elements['//cas:authenticationFailure'].text.strip
      else
        # this should never happen, since the response should already have been recognized as invalid
        raise BadResponseException, "BAD CAS RESPONSE:\n#{raw_text.inspect}\n\nXML DOC:\n#{doc.inspect}"
      end
    end
  end
end