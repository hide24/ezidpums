class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def render(template, options={})
    options[:template] = template
    action_view = ActionView::Base.new(Rails.root.join('app', 'views'))
    action_view.assign instance_variables.each_with_object({}){|name, hash| hash[name[1..-1]] = instance_variable_get(name)}
    action_view.render(options)
  end
end
