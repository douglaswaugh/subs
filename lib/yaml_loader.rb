class YamlLoader
  def load(file_path)
    return YAML.load_file(file_path)
  end
end