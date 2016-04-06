class Hash
  def rename_key(key, name)
    self.inject({}) do |obj, (k, v)|
      k.to_sym == key ? obj[name] = v : obj[k] = v
      obj
    end
  end
end
