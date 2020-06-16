module ApplicationHelper

  def notification(class_names, closable = true)
    content_tag(:div, class: ['notification', class_names]) do
      concat(content_tag(:button, nil, class: 'delete')) if closable
      yield if block_given?
    end
  end

  def form_field_errors(model, field_name)
    return unless model.errors.key?(field_name)

    content_tag(:p, class: 'help is-danger') do
      model.errors[field_name].join(", ")
    end
  end

end
