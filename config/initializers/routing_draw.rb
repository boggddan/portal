class ActionDispatch::Routing::Mapper
  def draw(routes_name, sub_path = nil)
    sub_path = sub_path.present? ? "/#{ sub_path }" : ''
    instance_eval(File.read(Rails.root.join("config/routes#{ sub_path }/#{routes_name}.rb")))
  end
end
