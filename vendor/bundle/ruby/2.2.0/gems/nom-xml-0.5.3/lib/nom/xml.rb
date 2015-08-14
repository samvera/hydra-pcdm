require 'nokogiri'

module Nom
  module XML
    require 'nom/xml/version'
    require 'nom/xml/term'
    require 'nom/xml/terminology'
    require 'nom/xml/template_registry'
    require 'nom/xml/decorators'

    require 'nom/xml/nokogiri_extension'

    Nokogiri::XML::Document.send(:include, NokogiriExtension)
  end
end

