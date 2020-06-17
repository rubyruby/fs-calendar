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
      model.errors[field_name].join(', ')
    end
  end

  def form_field(model, field_name, &block)
    field_class = model.errors.key?(field_name) ? 'is-danger' : ''
    content_tag(:div, class: 'field') do
      label(model.model_name.param_key, field_name, class: 'label') +
        content_tag(:div, class: 'control') { block.call(field_class) if block } +
        form_field_errors(model, field_name)
    end
  end

end
