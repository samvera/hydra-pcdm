# -*- encoding: utf-8 -*-

class ::Hash

  # Returns self with keys uncamelized and converted to symbols.
  def uncamelize_and_symbolize_keys
    self.uncamelize_and_stringify_keys.symbolize_keys
  end

  # Returns self with keys uncamelized and converted to strings.
  def uncamelize_and_stringify_keys
    uncamelized = {}
    self.each_pair do |key, value|
      new_key = key.to_s.split(/(?=[A-Z])/).join('_').downcase
      uncamelized[new_key] = value
    end

    uncamelized
  end

  # Returns self with all keys symbolized.
  def symbolize_keys
    symbolized = {}
    self.each_pair do |key, value|
      symbolized[key.to_sym] = value
    end

    symbolized
  end unless self.method_defined?(:symbolize_keys)

end # class Hash
