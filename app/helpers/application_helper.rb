module ApplicationHelper

  def form_field_errors(model, field_name)
    return unless model.errors.key?(field_name)

    content_tag(:p, class: 'help is-danger') do
      model.errors[field_name].join(", ")
    end
  end

end
